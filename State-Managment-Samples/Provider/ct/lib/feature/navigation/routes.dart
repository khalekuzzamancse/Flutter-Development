import 'package:flutter/material.dart';
import 'package:snowchat_ios/feature/chat/data/entity/peer_entity.dart';
import 'package:snowchat_ios/feature/chat/domain/model/message_model.dart';
import 'package:snowchat_ios/feature/chat/domain/model/conversation_model.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/ui/create_group.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/about_us.dart';

import '../../core/ui/media_viewer.dart';
import '../../main.dart';
import '../auth/presentation/ui/forget_password_screen.dart';
import '../auth/presentation/ui/login_screen.dart';
import '../auth/presentation/ui/register_screen.dart';
import '../auth/presentation/ui/set_new_passwrod_screen.dart';
import '../auth/presentation/ui/verify_screen.dart';
import '../chat/presentation/ui/chat_and_messages_screen.dart';
import '../chat/presentation/ui/forward_message.dart';
import '../chat/presentation/ui/group_chat_screen.dart';
import '../contact_list/domain/model/contact_model.dart';
import '../contact_list/presentation/contact_list_screen.dart';
import '../group_chat/presentation/ui/group_admin_list_screen.dart';
import '../group_chat/presentation/ui/group_member_list_screen.dart';
import '../group_chat/presentation/ui/add_members_screen.dart';
import '../group_chat/presentation/ui/remove_members_screen.dart';
import '../home/home.dart';
import '../misc/presentation/ui/account_setting_screen.dart';
import '../misc/presentation/ui/contact_us.dart';
import '../misc/presentation/ui/help_center_screen.dart';
import '../misc/presentation/ui/help_screen.dart';
import '../misc/presentation/ui/notification_setting_screen.dart';
import '../misc/presentation/ui/privacy_policy_screen.dart';
import '../misc/presentation/ui/setting_screen.dart';
import '../misc/presentation/ui/term_and_condtion_screen.dart';
import '../profile_management/presentation/ui/edit_profile.dart';
import '../profile_management/presentation/ui/profile.dart';

class Navigation {
  //TODO: Related to media viewer
  static goToImageViewer(BuildContext context, String url) {}

  static goToForwardMessageScreen(BuildContext context, MessageModel msg) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForwardMessageScreen(message: msg)));
  }

  static goToContactPermission(BuildContext context) =>
      push(context, const ContactScreen());

  static push(BuildContext context, Widget route) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => route,
        ));
  }
  static Future<dynamic> pushAsync(BuildContext context, Widget route)=> Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => route,
        ));

  static void popUntilHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => const SnackBarDecorator(content: HomeScreen())),
      (Route<dynamic> route) => false,
    );
  }

  //TODO: Related to media viewer
  static goToVideoViewer(BuildContext context, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoViewer(url: url),
        ));
  }

  //TODO: Related to media viewer
  static goToViewProfile(
      BuildContext context, ConversationPersonalPeerEntity model) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewProfile(model: model),
        ));
  }

  //TODO:Chat Related
  static goToGroupMembersScreen(int conversationId, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GroupMembersListScreen(conversationId: conversationId),
        ));
  }

  static goToGroupAdminsScreen(int conversationId, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GroupAdminListScreen(conversationId: conversationId),
        ));
  }

  static goToAddNewMemberToGroupScreen(int conversationId, BuildContext context) =>
      push(context, AddNewMemberToGroupScreen(conversationId: conversationId));

  static goToRemoveMemberToGroupScreen(
      int conversationId, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RemoveMemberToGroupScreen(conversationId: conversationId),
        ));
  }

  static gotoAboutUs(BuildContext context)=>push(context, AboutUsScreen());

  static gotoPrivacyPolicy(BuildContext context)=>push(context, PrivacyPolicyScreen());

  static goToTermsAndCondition(BuildContext context) =>push(context, TermsAndConditionScreen());

  static gotoContactUs(BuildContext context)=>push(context, ContactUsScreen());

  static gotoVerifyCode(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerifyCodeScreen(),
        ));
  }

  static gotoLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  static logOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  static gotoNewGroup(BuildContext context)=> push(context, const NewGroupMember());

  static gotoCreateGroup(
      BuildContext context, List<ContactModel> selectedContact) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreateGroupScreen(selectedContacts: selectedContact),
        ));
  }

  static navigateToChat(ConversationModel model, BuildContext context)=>push(context,  ChatScreen(model: model));


  static navigateToProfile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen1(
            onEditRequest: () {
              navigateToEditProfile(context);
            },
          ),
        ));
  }

  static navigateToEditProfile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditProfileScreen(),
        ));
  }

  static navigateToContactList(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactListScreen(),
        ));
  }

  static navigateToGroupChat(ConversationModel model, BuildContext context)
  =>push(context,  GroupChatScreen(conversation: model));

  static navigateToSetting(BuildContext context) =>push(context, const SettingScreen());



  static goToHelpCenter(BuildContext context) =>push(context,  HelpCenterScreen());

  static navigateToAccountSetting(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountSettingScreen(),
        ));
  }

  static navigateToNotificationSetting(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationSettingScreen(),
        ));
  }

  static navigateToHelp(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HelpScreen(),
        ));
  }

  static navigateToForgetPassword(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgetPasswordScreen(),
        ));
  }

  static goToSetNewPassword(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetNewPasswordScreen(),
        ));
  }

  static goToHome(BuildContext context) {
    //decorator with ConfirmExitDecorator so that first time comes through Login screen then exit dialog show
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ConfirmExitDecorator(child: HomeScreen()),
        ));
  }

  static navigateToRegister(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        ));
  }
}
