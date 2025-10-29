import 'package:get/get.dart';

import '../../../di/global_controller.dart';
import '../../data/misc_entity.dart';
import '../../data/misc_info_repository.dart';

class HelpCenterController extends GetxController {
  var isLoading = false.obs;
  Rx<MiscInfoEntity?> helpCenter = Rx<MiscInfoEntity?>(null);
  final className = 'HelpCenterController';
  void read() async{
    try {
      isLoading.value = true;
      helpCenter.value=  await MiscInfoRepository().readHelpCenter();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }

  }
}
