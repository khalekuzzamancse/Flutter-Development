part of core_ui;

class ThemeInfo {
  static const appBlue = Color(0xFF194771);
  static const appBlueLight = Color(0xFF194771);
  static const appBlueDark = Color(0xFF0E2A44);
  static const appActionBlue=  Colors.blue;
  static Color textFieldBorderColors = HexColor("#1F7396");
  static const TextStyle textFieldStyle=TextStyle(fontSize: 14,color:Colors.black);
  static const Radius searchBarRadius= Radius.circular(8);
  static const headerButtonHeight=48.0;
  static const headerButtonIconSize=30.0;
  static OutlinedBorder  headerButtonShape= RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
  static const  headerButtonLabelStyle=TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  static const appRed=  Color(0xFFD32F2F);
  static const productColor=Color(0xFF2196F3);
  static const categoryColorUnselected=Color(0xFF194771);
  static const categoryColorSelected=Color(0xFF1F7396);
  static const searchIconColor=Color(0xFF00B2FF);
  static const cartItemSelectionColor=Color(0xFF00D1FF);
  static const payNowButtonColors=Color(0xFF5990FF);
  static const saveButtonColor=Color(0xFF73D578);
  static const cartRemoveIconSize=20.0;
  static const Color addCustomerButtonColor = Color(0xFF2196F3);
  ///According to Figma there should Gap between the SearchAction and the Category+Product Grid
  static const productActionAndProductGridTopGap=8.0;
  static const Color categoryScrollBarBackGround = Color(0xFF005477);
  static const Color categoryScrollbarColor = Color(0xFF0FAAEB);
  static const Color billNoBackground= Color(0xFF194771);
  static const Color tableNoBorderColor = Color(0xFF2F80ED);
  static const Color tableNoBackgroundColor = Color(0xFF1D3347);
  static const listBackground= Color(0xFF194771);
  static final tableBackground=ThemeInfo.appBlueDark.withOpacity(0.4);
  ///Table horizontal padding
  static const tableHPadding=EdgeInsets.symmetric(horizontal: 10);
  static const tableHorizontalPadding=10.0;
  static const  cartBackground=Color(0xFF153D61);






}
