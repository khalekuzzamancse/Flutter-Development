
import 'package:get/get_rx/src/rx_types/rx_types.dart';
abstract interface class LoadingController{
  Rx<bool> get isLoading;
 void startLoading();
  void stopLoading();
}
mixin LoadingControllerImplMixin {
  final Rx<bool> isLoading=false.obs;
  void startLoading(){
    isLoading.value=true;
    isLoading.refresh();
  }
  void stopLoading(){
    isLoading.value=false;
    isLoading.refresh();
  }
}


abstract interface class PaginationController {
  Rx<int> get totalPages;
  Rx<int> get currentPage;
  Rx<int> get totalItem;

  void gotoNextPage();

  void gotoPrevPage();

  void gotoPage(int page);
}

mixin PaginationControllerMixin implements PaginationController {
  @override
  Rx<int> totalPages = Rx<int>(0);
  @override
  Rx<int> currentPage = Rx<int>(0);
  @override
  Rx<int>  totalItem = Rx<int>(0);
  void updateTotalItem(int total){
    totalItem.value=total;
    totalItem.refresh();

  }

  void setInitialPage(int totalPages) {
    this.totalPages.value = totalPages;
    this.totalPages.refresh();
    if (totalPages > 0) {
      currentPage.value = 1;
      currentPage.refresh();
    }
  }

  @override
  void gotoNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      currentPage.refresh();
    }
  }

  @override
  void gotoPrevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      currentPage.refresh();
    }
  }

  @override
  void gotoPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      currentPage.refresh();
    }
  }
}


