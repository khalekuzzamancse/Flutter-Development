import 'package:get/get.dart';

import '../../../di/global_controller.dart';
import '../../data/misc_entity.dart';
import '../../data/misc_info_repository.dart';
class AboutUsController extends GetxController {
  var isLoading = false.obs;
  Rx<MiscInfoEntity?> aboutUsInfo = Rx<MiscInfoEntity?>(null);
  final className = 'AboutUsController';
  void read() async{
    try {
      isLoading.value = true;
      aboutUsInfo.value=  await MiscInfoRepository().readAboutUs();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }

  }
}
