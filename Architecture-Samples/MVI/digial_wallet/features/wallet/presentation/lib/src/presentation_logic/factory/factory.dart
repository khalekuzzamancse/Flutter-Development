import '../controller/controller.dart';
import 'controller_impl.dart';

class PresentationFactory{
  static Controller createController()=>ControllerImpl();
}