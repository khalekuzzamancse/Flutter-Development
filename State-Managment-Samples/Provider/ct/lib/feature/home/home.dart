import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';
import 'package:snowchat_ios/feature/profile_management/presentation/presentation_logic/profile_controller.dart';
import 'package:snowchat_ios/main.dart';
import '../../core/ui/loading_overlay.dart';
import '../../core/ui/search_decorator.dart';
import '../chat/presentation/presentationLogic/conversation_controller.dart';
import '../chat/domain/model/conversation_model.dart';
import '../chat/presentation/ui/conversation_list.dart';
import '../navigation/routes.dart';
import 'drawer.dart';
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isSearchActive = false;
  final conversationsController = Get.put(ConversationController());
  final profileController = Get.put(ProfileController());

  HomeScreenState() {
    conversationsController.read();
    profileController.read();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = conversationsController.isLoading.value;
      final models = conversationsController.conversations;
        return _isSearchActive
            ? Scaffold(
                body: SearchDecorator(
                  content: Center(
                      child: ConversationList(
                    onEnd: conversationsController.onEndOfList,
                    maxWidth: 500.0,
                    // Maximum width for the list
                    conversations: models,
                    onChatClicked: (model) async{
                      await Navigation.navigateToChat(model, context);
                      conversationsController.refreshData();
                    },
                    onDeleteRequest: (conversation) {},
                  )),
                  hint: 'Type to search...',
                  backgroundColor: Colors.blueGrey[50]??Colors.blueGrey,
                  iconColor: Colors.blue,
                  hintColor: Colors.blueGrey,
                  onQuery: (query) {
                    conversationsController.onLocalSearch(query);
                  },
                  onBack: () {
                    setState(() {
                      _isSearchActive = false;
                    });
                  },
                ),
              )
            : _HomeScreen(
                onBack: conversationsController.refreshData,
                onEnd: conversationsController.onEndOfList,
                isLoading: isLoading,
                models: models,
                onSearchRequest: () {
                  setState(() {
                    _isSearchActive = true;
                  });
                },
                onDeleteRequest: (conversation) {
                  conversationsController.deleteConversation(conversation.id);
                },
              );
      //}
    });
  }
}

class _HomeScreen extends StatelessWidget {
  final VoidCallback? onSearchRequest;
  final Function(ConversationModel) onDeleteRequest;
  final List<ConversationModel> models;
  final VoidCallback onEnd, onBack;
  final bool isLoading;

  const _HomeScreen(
      {super.key,
      this.onSearchRequest,
      required this.models,
      required this.onDeleteRequest,
      required this.onEnd,
      required this.onBack,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: Builder(
          builder: (context) => CustomMenuIcon(
            onClick: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: onSearchRequest,
          ),
        ],
      ),
      drawer: CustomDrawer(
        onBack: (){
          closeDrawer();
          onBack();
        },
        onClick: (item) async {
          closeDrawer();
          if (item == DrawerItem.settings) {
            if (context.mounted) {
              await Navigation.navigateToSetting(context);
              onBack();
            }
          }
          if (item == DrawerItem.newGroup) {
            if (context.mounted) {
             await Navigation.gotoNewGroup(context);
             onBack();

            }
          }
          if (item == DrawerItem.aboutUs) {
            if (context.mounted) {
              Navigation.gotoAboutUs(context);
              onBack();
            }
          }
          if (item == DrawerItem.contactUs) {
            if (context.mounted) {
              Navigation.gotoContactUs(context);
              onBack();
            }
          }
          if (item == DrawerItem.privacyPolicy) {
            if (context.mounted) {
              Navigation.gotoPrivacyPolicy(context);
              onBack();
            }
          }
          if (item == DrawerItem.termsAndConditions) {
            if (context.mounted) {
              Navigation.goToTermsAndCondition(context);
              onBack();
            }
          }
          if (item == DrawerItem.logOut) {
            restartApp();
          }
          // Navigator.pop(context); // Close the drawer after clicking
        },
      ),
      body: isLoading? const FullScreenShimmerEffect():Center(
          child: models.isEmpty
              ? const EmptyContact()
              : ConversationList(
                  onEnd: onEnd,
                  maxWidth: 500.0,
                  // Maximum width for the list
                  conversations: models,
                  onChatClicked: (model) async {
                    if (model.isGroupChat) {
                     await Navigation.navigateToGroupChat(model, context);
                    } else {
                   await   Navigation.navigateToChat(model, context);
                    }
                    onBack();
                  },
                  onDeleteRequest: onDeleteRequest,
                )),
      floatingActionButton: _FabIcon(
        onClick: () async {
          await Navigation.goToContactPermission(context);
          onBack();
        },
      ),
    );
  }
  void closeDrawer(){
    try{
        scaffoldKey.currentState!.openEndDrawer();
    }
    catch(_){}
  }
}

class EmptyContact extends StatelessWidget {
  const EmptyContact({super.key});

  // Define the custom TextStyle variable for this screen
  static const TextStyle _customTextStyle = TextStyle(
    fontSize: 16.0, // Set the font size
    color: AppColor.headingText, // Set the color for all text
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: _customTextStyle, // Apply the custom TextStyle to all text
            children: [
              const TextSpan(
                text: 'To start messaging who have a SnowTex, ',
              ),
              TextSpan(
                text: 'tap Contact Button',
                style: _customTextStyle.copyWith(
                    fontWeight: FontWeight.bold), // Bold for this part
              ),
              const TextSpan(
                text: ' at the bottom of your screen.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMenuIcon extends StatelessWidget {
  final VoidCallback onClick;

  const CustomMenuIcon({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: Material(
            //  elevation: 2, // Adds a shadow effect
            color: Colors.transparent,
            // Make sure the Material has a transparent color
            borderRadius: BorderRadius.circular(8),
            // Optional: rounded corners for the effect
            child: InkWell(
              onTap: onClick,
              borderRadius: BorderRadius.circular(8),
              // Optional: same border radius for the InkWell
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // Optional: padding for the image
                child: Image.asset(
                  'assets/image/menu_bar.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FabIcon extends StatelessWidget {
  final VoidCallback onClick;

  const _FabIcon({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Adjust the width
      height: 60, // Adjust the height to make it rounded
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius:
            BorderRadius.circular(30), // Half the height for a perfect circle
      ),
      child: IconButton(
        onPressed: onClick,
        icon: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}
