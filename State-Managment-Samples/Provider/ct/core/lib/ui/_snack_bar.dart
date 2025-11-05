part of core_ui;

String? _currentMsg;

void snackBarWithError(Object e) {
  String? error;
  if (e is CustomException) {
    error = e.message;
  } else if (e is ClientException) {
    error = 'Unable to connect server';
  } else {
    error = 'Something is went wrong';
  }
  showSnackBar(error,tag: 'snackBarWithError');
}

void showSnackBar(String? message, {String? tag}) async {
  try{
    if (tag != null) {
      Logger.on('$tag::showSnackBar', '$message');
    }
    //already the same message shown
    if (_currentMsg == message) {
      return;
    }
    _currentMsg = message;
    if (message == null) {
      return;
    }
    await Get.snackbar('', '',
        titleText: Text(message),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        borderRadius: 10,
        backgroundColor: AppColors.white,
        maxWidth: 300)
        .future;
    _currentMsg = null;
  }
  catch(_){}

}
