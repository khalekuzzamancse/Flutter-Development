import 'package:get/get.dart';

import '../../../di/global_controller.dart';
import '../../data/misc_entity.dart';
import '../../data/misc_info_repository.dart';

class PrivacyPolicyController extends GetxController {
  var isLoading = false.obs;
  Rx<MiscInfoEntity?> privacyInfo = Rx<MiscInfoEntity?>(null);
  final className = 'MiscController';
   PrivacyPolicyController();

  void read() async{
    try {
      isLoading.value = true;
      privacyInfo.value=  await MiscInfoRepository().readPrivacyPolicy();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }

  }
}
