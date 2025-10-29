import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';

import '../../../../core/ui/loading_overlay.dart';
import '../../../chat/data/entity/peer_entity.dart';
import '../../../di/global_controller.dart';
import '../../../navigation/routes.dart';
import '../presentation_logic/profile_controller.dart';

class ViewProfile extends StatelessWidget {
  final ConversationPersonalPeerEntity model;
  const ViewProfile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showEditAction=Get.find<GlobalController>().authInfo.currentUserId==model.id;
    return  SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 250,
                  color: AppColor.primary,
                  child: ProfileHeader(
                    name: model.name,
                    imageUrl: model.image??'',
                    onEditRequest: (){},
                  ),
                ),
              ],
            ),
            Positioned(
              top: 150, // Adjust based on header height
              left: 16,
              right: 16,
              child: ElevatedProfileSurface(
                onEditRequest:(){
                  Navigation.navigateToEditProfile(context);
                },
                name: model.name,
                phone: model.phone,
                email:model.email,
                editButtonText: showEditAction?'Edit Profile':null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfileScreen1 extends StatelessWidget {
  final VoidCallback onEditRequest;

  const ProfileScreen1({
    Key? key,
    required this.onEditRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final model = controller.userModel.value;

      return LoadingOverlay(
          isLoading: isLoading,
          content: model == null
              ? const SizedBox(width: 100, height: 100)
              : SafeArea(
                child: Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 250,
                              color: AppColor.primary,
                              child: ProfileHeader(
                                name: '${model.firstName} ${model.lastName}',
                                imageUrl: model.imageUrl,
                                onEditRequest: onEditRequest,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 150, // Adjust based on header height
                          left: 16,
                          right: 16,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 400),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 400),
                              child: ElevatedProfileSurface(
                                onEditRequest: onEditRequest,
                                name: '${model.firstName} ${model.lastName}',
                                phone: model.mobile,
                                email: model.email,
                                editButtonText: 'Edit Profile',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ));
    });
  }
}

class ProfileHeader extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onEditRequest;


  const ProfileHeader({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onEditRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   const  topMargin=40.0;
    return Container(
      width: double.infinity, // Ensures the header fills the available width
      color: AppColor.primary, // Blue background color
        child: Stack(
          children: [
            Positioned(
              top: topMargin-5,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(child: _AvatarAndName(name: name, imageUrl: imageUrl,topMargin: topMargin))
          ],
        ),
    );
  }
}

class _AvatarAndName extends StatelessWidget {
  final double topMargin;
  final String name;
  final String imageUrl;

  const _AvatarAndName({super.key, required this.name, required this.imageUrl,required this.topMargin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(height: topMargin),
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ElevatedProfileSurface extends StatelessWidget {
  final VoidCallback onEditRequest;
  final String name;
  final String phone;
  final String email;
  ///Null for read only profile or ui profile
  final String? editButtonText;

  const ElevatedProfileSurface({
    Key? key,
    required this.onEditRequest,
    required this.name,
    required this.phone,
    required this.email,
    this.editButtonText = 'Edit Profile',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
           _ProfileData2(name: name,email: email,phone: phone),
            if(editButtonText!=null)
            Positioned(
              top: 0,
              child: ElevatedButton(
                onPressed: onEditRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 4.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                ),
                child: Text(
                  editButtonText!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: AppColor.headingText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ProfileData2 extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  const _ProfileData2({super.key, required this.name, required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
      margin: const EdgeInsets.only(top: 24.0),
      padding:
      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileDetailRow(
            icon: Icons.person_outline,
            label: name,
          ),
          const Divider(),
          _ProfileDetailRow(
            icon: Icons.phone_outlined,
            label: phone,
          ),
          const Divider(),
          _ProfileDetailRow(
            icon: Icons.email_outlined,
            label: email,
          ),
          //TODO:Be careful may causes render issue in release mode
          const Flexible(child: SizedBox(height: 100)),
          //For extra bottom padding according to Figma design
        ],
      ),
    );
  }
}



class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.primary,
            size: 24.0,
          ),
          const SizedBox(width: 16),
          //TODO:Be careful may causes render issue in release mode
          Flexible(child: _CopyTextWidget(label: label))
        ],
      ),
    );
  }
}


class _CopyTextWidget extends StatelessWidget {
  final String label;

  const _CopyTextWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        // Copy the text to the clipboard
        Clipboard.setData(ClipboardData(text: label));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      },
      //TODO:Using Flexible/Expanded  causes  the render issue in release mode android
      //but if not using then text overlap and show the issue on debug mode
      //TODO:Fix it later
      child: Text(
        label,
        style:const TextStyle(
          fontSize: 16,
          color: AppColor.headingText,
        ),
      ),

    );
  }
}

