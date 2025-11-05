import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../feature/misc/presentation/ui/core.dart';
import '../misc/logger.dart';
import 'app_color.dart';

class ContactPermissionController   {
  final String reason='Need contact permission to find friend for chat';
  final _class = 'ContactPermissionController';

  final Permission _permissions=Permission.contacts;
  var hasPermission = false.obs;
  ContactPermissionController(){
    _updatePermissionStatus();
  }
  Future<bool> hasAllGranted() async {
    final tag = '$_class::hasAllGranted';
    final PermissionStatus result = await _permissions.status;
    Logger.debug(tag, 'result:$result');
    _updatePermissionStatus();
    return  result.isGranted;
  }

  void _updatePermissionStatus() async {
    hasPermission.value = await hasAllGranted();
    hasPermission.refresh();
  }

  ///Okay to pass the context, since we are not storing that
  Future<bool> request(BuildContext context) async {
    final tag = '$_class::request';
    PermissionStatus statuses = await _permissions.request();
    _updatePermissionStatus();
    if (statuses.isPermanentlyDenied) {
      if (context.mounted) {
        await _showPermissionDialog(context, reason);
        _updatePermissionStatus();
        Logger.debug(tag, 'afterDialog back,status:${hasPermission.value}');
      }
    }
    _updatePermissionStatus();
    hasPermission.refresh();
    Logger.debug(tag, 'status:${hasPermission.value}');
    return await hasAllGranted();
    // return status;
  }

  Future<void> _showPermissionDialog(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content:  const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unable to load contact,Go to Settings > Permissions, then allow the following permissions and try again',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.contacts, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Contact',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'DISMISS',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                try {
                  Navigator.of(context).pop();//Not work together with setting open
                  openAppSettings();
                } catch (_) {}
              },
              child: Text(
                'GO TO SETTINGS',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MediaPermissionController   {
  static  List<Permission> mediaPermission= [
  Permission.camera,
  Permission.storage,
  //on Android >13 , permission is always denied but need to use this for android <13
  Permission.photos,
  Permission.videos,
  ];
  static String mediaPermissionReason='Camera Access Needed,Go to  settings, tap permissions, and tap allow';
  final _class = 'PermissionController';



  final  String reason;
  final List<Permission> _permissions;

  MediaPermissionController({required List<Permission> permission,required this.reason}) : _permissions = permission {
    _updatePermissionStatus();
  }
  var hasPermission = false.obs;

  Future<bool> hasAllGranted() async {
    final tag = '$_class::hasAllGranted';
    final List<PermissionStatus> result =
        await Future.wait(_permissions.map((permission) => permission.status));
    final cameraGranted = result[0].isGranted;
    final storageGranted = result[1].isGranted;
    final photoGranted = result[2].isGranted;
    final videoGranted = result[3].isGranted;
    final photoOrVideoGranted = photoGranted || videoGranted;
    final mediaGranted = storageGranted || photoOrVideoGranted;
    Logger.debug(tag, 'result:$result');
    return cameraGranted && mediaGranted;
  }

  void _updatePermissionStatus() async {
    hasPermission.value = await hasAllGranted();
    hasPermission.refresh();
  }

  ///Okay to pass the context, since we are not storing that
  Future<bool> request(BuildContext context) async {
    final tag = '$_class::request';
    Map<Permission, PermissionStatus> statuses = await _permissions.request();
    _updatePermissionStatus();
    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      if (context.mounted) {
        await _showPermissionDialog(context, reason);
        _updatePermissionStatus();
        Logger.debug(tag, 'afterDialog back,status:${hasPermission.value}');
      }
    }
    _updatePermissionStatus();
    hasPermission.refresh();
    Logger.debug(tag, 'status:${hasPermission.value}');
    return await hasAllGranted();
    // return status;
  }

  Future<void> _showPermissionDialog(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content:
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unable to open Gallery,Go to Settings > Permissions, then allow the following permissions and try again',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.folder, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Storage',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.camera, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Camera',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          )
          ,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'DISMISS',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                try {
              //  Navigator.of(context).pop();//Not work together with setting open
                  openAppSettings();//pushing
                } catch (_) {}
              },
              child: Text(
                'GO TO SETTINGS',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MediaPermissionScreen extends StatelessWidget {
  final MediaPermissionController controller;

  const MediaPermissionScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isGranted=controller.hasPermission.value;
    return GenericScreen(
      title: 'Permission',
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MediaDisclosure(),
              const SizedBox(height: 16),
              if (!isGranted) ...[
                ElevatedButton(
                  onPressed: ()async{
                    final granted=await controller.request(context);
                    Logger.debug('_PermissionScreenState', 'granted:$granted');
                    if(granted){
                      if(context.mounted){
                        Navigator.pop(context);
                      }

                    }
                  },
                  child: const Text('Allow Permission'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ContactPermission extends StatelessWidget {
  final ContactPermissionController controller;
  const ContactPermission({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isGranted=controller.hasPermission.value;
    return   GenericScreen(
      title: 'Permission',
      content: SingleChildScrollView(
        child: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _ContactDisclosure(),
              const SizedBox(height: 16),
              if (!isGranted) ...[
                ElevatedButton(
                  onPressed: ()async{
                    final granted=await controller.request(context);
                    Logger.temp('ContactPermission', 'granted:$granted');
                    if(granted){
                      if(context.mounted){
                        Navigator.pop(context);
                      }

                    }
                  },
                  child: const Text('Allow Permission'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
class _ContactDisclosure extends StatelessWidget {
  const _ContactDisclosure({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.contacts_outlined, // Placeholder for the icon at the top
            size: 48,
            color: AppColor.primary,
          ),
          SizedBox(height: 16),
          Text(
            'DISCLOSURE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Know what info SnowChat collects, find details in our privacy policy, agree by clicking Agree.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Your phone number is used for sign-up, login, password recovery, and verifying your identity and other services.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Contacts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Used to find and connect with friends and family.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaDisclosure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_outlined, size: 40,color: Colors.grey,),
              SizedBox(width: 8),
              Text(
                '+',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Colors.grey),
              ),
              SizedBox(width: 8),
              Icon(Icons.camera_alt_outlined, size: 40,color: Colors.grey,),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'DISCLOSURE',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Know what info SnowChat collects, find details in our privacy policy, agree by clicking Agree. '
                'Tap Settings > Permissions, and turn Camera on and "Files and media" on.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Camera',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Used to capture photos and videos.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Photos, Media And Files',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'To send media.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
