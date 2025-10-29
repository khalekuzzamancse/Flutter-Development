import 'package:get/get.dart';

import '../../../di/global_controller.dart';
import '../../data/misc_entity.dart';
import '../../data/misc_info_repository.dart';

class TermAndConditionController extends GetxController {
  var isLoading = false.obs;
  Rx<MiscInfoEntity?> termAndCondition = Rx<MiscInfoEntity?>(null);
  final className = 'TermAndConditionController';

  void read() async{
    try {
      isLoading.value = true;
      termAndCondition.value=  await MiscInfoRepository().readTerms();
    } catch (e) {
      Get.find<GlobalController>().onError(e);
    } finally {
      isLoading.value = false;
    }

  }
}
