import 'package:auth/chat/chat_and_messages_screen.dart';
import 'package:auth/conversation/conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:restart_app/restart_app.dart';
import 'package:snowchat_ios/core/domain/media_type.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/misc/time_formatter.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';
import 'package:snowchat_ios/feature/auth/presentation/ui/login_screen.dart';
import 'package:snowchat_ios/feature/home/home.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/welcome_screen.dart';
import 'feature/chat/presentation/presentationLogic/picked_media_model.dart';
import 'feature/chat/presentation/ui/forward_message.dart';
import 'feature/contact_list/presentation/contact_list_screen.dart';
import 'feature/di/auth_preserver.dart';
import 'feature/di/global_controller.dart';
import 'feature/misc/presentation/ui/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isStartViaDeepLink=false;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(GlobalController());
    runApp(MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppColor.theme,
      home: ChatAndMessagesScreen(),
      //home: const ConfirmExitDecorator(child: MyApp()),
    ));

}

///May not work windows, works on android and and ios
///Use after Logout and session expire to avoid hidden bug or edge case
///because restarting will clean the old state and start from fresh once which is good.
///
///
///but navigating or clear back stack may cause some issues such as:
//
//   The following assertion was thrown building Obx(has builder, dirty, state: ObxState#541a5):
//   setState() or markNeedsBuild() called during build.
//
// This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
//  The widget on which setState() or markNeedsBuild() was called was: Overlay-[LabeledGlobalKey<OverlayState>#5fb78]
void restartApp() async {
  try {
    await Preserver.clear(); //Need to clear because after log out if go exit the app
    if (Get.isRegistered<GlobalController>()) {
      Get.delete<GlobalController>();
    }
    Restart.restartApp(
      notificationTitle: "Restart",
      notificationBody: 'Need to restart the app'
    );
  } catch (_) {}
}


class MyApp extends StatefulWidget {

   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(MyAppController());

  final tag = 'MyAppState';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showSplash = controller.showSplash.value;
      final isLogin = controller.isLogin.value;
      final isSessionExpire = controller.sessionExpire.value;
      final welcomeScreenShown = controller.welcomeScreenShown.value;
      if (isSessionExpire) {
        try {
          restartApp();
        } catch (_) {}
      }
      return Scaffold(
        body: SnackBarDecorator(
          content: showSplash
              ? const SplashScreen()
              : FirstScreen(isLoggedIn: isLogin, isWelcomeShown: welcomeScreenShown),
        ),
      );
    });
  }
  @override
  void initState() {
    super.initState();
    observerDeepLink();
  }
  void observerDeepLink() async {
    const tag = 'main::observerDeepLink';
    try {
      final List<SharedMediaFile> files = await ReceiveSharingIntent.instance.getInitialMedia();

      for (var file in files) {

        if(file.type==SharedMediaType.text){
          Logger.temp(tag, 'getInitialMedia :${file.message}');
        }

        if (navigatorKey.currentState != null) {
          final mediaType = _mapSharedMediaTypeToMediaType(file.type);
        await navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => ShareScreen(
              media: PickedMediaModel(
                type: mediaType,
                path: file.path,
                name: extractFileName(file.path),
              ),
            ),
          ));
        //after back from it
          SystemNavigator.pop();

        }

      }
    } catch (e) {
      Logger.temp(tag, 'Error receiving initial shared files: $e');
    }
  }

  MediaType _mapSharedMediaTypeToMediaType(SharedMediaType sharedType) {
    switch (sharedType) {
      case SharedMediaType.image:
        return MediaType.image;
      case SharedMediaType.video:
        return MediaType.video;
      default:
        return MediaType.otherFile;
    }
  }

}

class ConfirmExitDecorator<T> extends StatelessWidget {
  final Widget child;

  const ConfirmExitDecorator({Key? key, required this.child}) : super(key: key);

  Future<bool> _showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            // Stay in app
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => FlutterExitApp.exitApp(iosForceExit: true),
            // Exit app
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldExit ?? false; // Default to false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<T>(
      canPop: false, // Allow the back gesture by default
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Triggered when back press is blocked
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            if (context.mounted) {
              Navigator.of(context).maybePop(result);
            }
          }
        }

        return; // Prevent the pop if not allowed
      },
      child: child,
    );
  }
}

class MyAppController extends GetxController {
  final tag = 'MyAppController';
  var sessionExpire = false.obs;
  var isLogin = Rx<bool?>(null);
  var welcomeScreenShown = Rx<bool?>(null);
  var showSplash = true.obs; // Reactive variable

  MyAppController() {
    init();
  }

  Future<void> init() async {
    final isShown = await Preserver.shouldShowWelcomeScreen();
    onWelcomeScreenShownReady(isShown);

    final authInfo = await Preserver.getAuthInfo();
    onAuthInfoReady(authInfo);

    await stopSplash();
    Get.find<GlobalController>().setLoginSessionExpire(observeLoginSession);
  }

  Future<void> stopSplash() async {
    await Future.delayed(const Duration(seconds: 3), () {
      showSplash.value = false;
    });
  }

  void observeLoginSession() async {
    Logger.debug(tag, 'observeLoginSession:calling');
    try {
      await Preserver.clear();
      sessionExpire.value = true;
      sessionExpire.refresh();
    } catch (_) {}
  }

  void onWelcomeScreenShownReady(bool? hasShown) {
    Logger.debug(tag, 'shouldShowWelcomeScreen:$hasShown');
    if (hasShown == null) {
      welcomeScreenShown.value = false; // Not shown yet
    } else {
      welcomeScreenShown.value = hasShown;
    }
  }

  void onAuthInfoReady(AuthInfo? authInfo) {
    Logger.debug(tag, 'AuthInfo:$authInfo');
    if (authInfo != null) {
      Get.find<GlobalController>().updateAuthInfo(authInfo);
      isLogin.value = true;
    } else {
      isLogin.value = false;
    }
  }
}

class FirstScreen extends StatelessWidget {
  final bool? isWelcomeShown, isLoggedIn;

  const FirstScreen(
      {super.key, required this.isWelcomeShown, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    if (isWelcomeShown == null || isLoggedIn == null) {
      return const SplashScreen();
    }
    if (!isWelcomeShown!) {
      return const WelcomeScreen();
    }

    if (isLoggedIn!) {
      return const HomeScreen();
    }

    //not logged in
    return const LoginScreen();
  }
}

class SnackBarDecorator extends StatelessWidget {
  final Widget content;

  const SnackBarDecorator({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalController>();
    return Obx(() {
      // Get the current error message from ErrorMessageController
      final error = controller.errorMsg.value;
      Logger.debug('SnackBarDecorator:Obx', "$error");

      if (error != null) {
        // Show the SnackBar when the message is not null
        Future.microtask(() {
          //TODO:Fix it later, if we remove microtask() then causes error:SnackBar can not show while building
          if(context.mounted){
            showSnackBar(context, error);
          }

        });
      }

      // Return the content widget
      return content;
    });
  }
}

void showSnackBar(BuildContext context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      width: 300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: SnackBarAction(
        label: '✖️', //Since action has not built in support for cancel icon
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}