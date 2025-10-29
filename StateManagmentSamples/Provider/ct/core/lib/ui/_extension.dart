part of core_ui;
extension ColorExtension on Color {
  Color get contentColor => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
extension TextEditingControllerExtensions on TextEditingController{
  void setTextOrOriginal(String? text){
    this.text=text??this.text;
  }
}
extension SafeUpdateState on State {
  void safeSetState(void Function() updaterFunction) {
    void callSetState() {
      // Can only call setState if mounted
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(updaterFunction);
      }
    }


    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Currently building, can't call setState --
      // need to add post-frame callback
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
extension ContextExtension on BuildContext{
  Future<T?> push<T extends Object?>(Widget route)async{
    return await Navigator.push(this, MaterialPageRoute(builder: (_)=>route));
  }
  void pop<T extends Object?>([ T? result ]){
    return Navigator.pop(this,result);
  }
  ///In case of async-gap the context may  be invalid so can use it anywhere
  ///to prevent crash
   void popSafelyOrSkip<T extends Object?>([ T? result ]){
    if(mounted){
      Navigator.pop(this,result);
    }
  }


}

extension NavigatorExtension on Navigator{

}