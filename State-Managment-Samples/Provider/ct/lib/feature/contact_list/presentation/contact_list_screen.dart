import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/network/socket/socket_observer.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/core/ui/permission.dart';
import 'package:snowchat_ios/core/ui/spacer.dart';
import 'package:snowchat_ios/feature/contact_list/domain/model/contact_model.dart';

import '../../../core/ui/search_decorator.dart';
import '../../misc/presentation/ui/core.dart';
import '../../navigation/routes.dart';
import 'contact_list_controller.dart';
import 'core.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  final permissionController = ContactPermissionController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }


  void _checkPermission() async {
    await permissionController.hasAllGranted();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasPermission = permissionController.hasPermission.value;
      Logger.debug('ContactScreen', 'hasPermission:$hasPermission');
      if(isLoading){
        return const LoadingScreen();
      }
         return hasPermission ? const ContactListScreen() : ContactPermission(controller: permissionController);
    });
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  ContactListScreenState createState() => ContactListScreenState();
}

class ContactListScreenState extends State<ContactListScreen> {
  bool _isSearchActive = false;
  final _controller = ContactController();

  @override
  void initState() {
    super.initState();
    load();
    _controller.newConversationObserver=(conversation){
      Logger.temp('ContactListScreenState', '$conversation');
      if(context.mounted){
        Navigator.pop(context);
         Navigation.navigateToChat(conversation, context);

      }
    };
  }
  @override
  void dispose() {
    super.dispose();
    _controller.clearResources();
  }

  void load() async {
    //TODO:Library or framework related task should not be in the presentationLogicLayer controller that is doing in the ui layer
    try {
      _controller.startLoading();
      if (await FlutterContacts.requestPermission()) {
        List<Contact> loadedContact = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: false);
        final List<String> deviceContacts = [];
        //Logger.temp(tag, 'loadedContact:$loadedContact');
        for (final contact in loadedContact) {
          for (final phone in contact.phones) {
            String phoneNumber = phone.number
                .replaceAll(RegExp(r'[-\s]'), ''); // Remove spaces and dashes
            if (!phoneNumber.startsWith('+88')) {
              phoneNumber = '+88$phoneNumber'; // Add +88 if not present
            }
            deviceContacts.add(phoneNumber);
          }
        }
        _controller.postContact(deviceContacts);
      }
      _controller.startLoading();
      _controller.read();
    } catch (e) {
      _controller.postContact([]);
      _controller.read();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contacts = _controller.contacts;
      for (var con in contacts) {
        //   print("con:$con");
      }
      Logger.debug('ContactListScreenState', 'contact:$contacts');
      return LoadingOverlay(
          isLoading: _controller.isLoading.value,
          content: _isSearchActive
              ? SearchDecorator(
                  content: NonSelectableContacts(
                      models: contacts,
                      onClick: (model) async {
                        //Avoid to block UI thread
                        _controller.openConversation(model.id);

                       // Navigator.pop(context); //Tell homeScreen to refresh the conversation list because a new
                      }),
                  hint: 'Type to search...',
                  backgroundColor: Colors.blueGrey[50]!,
                  iconColor: Colors.blue,
                  hintColor: Colors.blueGrey,
                  onQuery: (query) {
                    _controller.onLocalSearch(query);
                  },
                  onBack: () {
                    setState(() {
                      _isSearchActive = false;
                    });
                  },
                )
              : _ContactListScreen(
                  models: contacts,
                  onClick: (model) async {
                    _controller.openConversation(model.id);
                    //Avoid to block UI thread
                   // Navigator.pop(context); //Tell homeScreen to refresh the conversation list because a new
                  },
                  onSearchClick: () {
                    setState(() {
                      _isSearchActive = true;
                    });
                  }));
    });
  }
}

class _ContactListScreen extends StatelessWidget {
  final List<ContactModel> models;
  final VoidCallback? onSearchClick;
  final Function(ContactModel model) onClick;

  const _ContactListScreen(
      {super.key,
      this.onSearchClick,
      this.models = const [],
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _TopBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
        contactCount: models.length,
        onSearchPressed: onSearchClick,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewContactOption(
            icon: Icons.groups_outlined,
            label: "New Group",
            onTap: () {
              Navigation.gotoNewGroup(context);
              //   Navigation.navigateToGroupChat(context);
            },
          ),
          NewContactOption(
            icon: Icons.person_add_alt_outlined,
            label: "New Contact",
            onTap: () async {
              //Source:https://pub.dev/packages/flutter_contacts
              if (await FlutterContacts.requestPermission()) {
                await FlutterContacts.openExternalInsert();
              }
            },
          ),
          const SpacerVertical8(),
          Expanded(
              child: NonSelectableContacts(
            models: models,
            onClick: onClick,
          ))
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final int contactCount;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onBackPressed;

  const _TopBar({
    Key? key,
    required this.contactCount,
    this.onSearchPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Contact",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            "$contactCount Contacts",
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: onSearchPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewContactOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const NewContactOption({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColor.primary,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        label,
        style: const TextStyle(color: AppColor.headingText, fontSize: 17),
      ),
      onTap: onTap,
    );
  }
}
