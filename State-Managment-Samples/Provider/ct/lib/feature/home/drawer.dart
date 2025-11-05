import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/ui/app_color.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/feature/profile_management/presentation/presentation_logic/profile_controller.dart';

import '../navigation/routes.dart';

//@formatter:off
enum DrawerItem { newGroup, linkedDevices, privacyPolicy, faq,
  termsAndConditions, settings, aboutUs, contactUs,logOut}


class CustomDrawer extends StatelessWidget {
  final Function(DrawerItem) onClick;
  final controller= Get.find<ProfileController>();
  final VoidCallback onBack;
   CustomDrawer({Key? key, required this.onClick, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              color: AppColor.primary,
              child: GestureDetector(
                onTap: () async{
                  if(context.mounted){
                    await Navigation.navigateToProfile(context);
                    onBack();
                  }

                },
                child:
                    Obx((){
                      final isLoading=controller.isLoading.value;
                      final model=controller.userModel.value;
                        return LoadingOverlay(
                            isLoading: isLoading,
                            content:model!=null? DrawerHeaderContent(
                                avatarUrl: model.imageUrl??'-',
                                name: '${model.firstName} ${model.lastName}',
                                phoneNumber: model.mobile,
                            ):const SizedBox.shrink()
                        );
                      // return LoadingOverlay(isLoading: isLoading, content: DrawerHeaderContent(
                      //   avatarUrl: 'https://avatars.githubusercontent.com/u/74848657?s=400&u=824db39937141324ea4ee2ea87d5f4d86dbe7828&v=4',
                      //   name: 'Md Khalekuzzaman',
                      //   phoneNumber: '+12334567784',
                      // ));
                    })
              )
              ,
            ),
            _buildDrawerItem(DrawerItem.newGroup, Icons.group_outlined, 'New Group'),
            _buildDrawerItem(DrawerItem.privacyPolicy, Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildDrawerItem(DrawerItem.termsAndConditions, Icons.task_outlined, 'Terms and Conditions'),
            _buildDrawerItem(DrawerItem.settings, Icons.settings_outlined, 'Settings'),
            _buildDrawerItem(DrawerItem.aboutUs, Icons.perm_device_info, 'About Us'),
            _buildDrawerItem(DrawerItem.contactUs, Icons.contacts_outlined, 'Contact Us'),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Action',style: TextStyle(color: AppColor.headingText),),
                ),
                _buildDrawerItem(DrawerItem.logOut, Icons.logout, 'LogOut'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(DrawerItem item, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon,color: AppColor.primary,),
      title: Text(title,style: const TextStyle(color: AppColor.headingText),),
      onTap: () => onClick(item),
    );
  }
}
class DrawerHeaderContent extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String phoneNumber;

  const DrawerHeaderContent({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarPadding = MediaQuery.of(context).padding.top;
    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical:statusBarPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 50,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              phoneNumber,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
