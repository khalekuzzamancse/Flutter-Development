import 'package:get/get.dart';

import '../../../di/global_controller.dart';
import '../../data/misc_entity.dart';
import '../../data/misc_info_repository.dart';

class ContactUsController extends GetxController {
  var isLoading = false.obs;
  Rx<MiscInfoEntity?> contactUsInfo = Rx<MiscInfoEntity?>(null);
  final className = 'ContactUsController';

  void read() async {
    try {
      isLoading.value = true;
      contactUsInfo.value = await MiscInfoRepository().readContactUs();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
