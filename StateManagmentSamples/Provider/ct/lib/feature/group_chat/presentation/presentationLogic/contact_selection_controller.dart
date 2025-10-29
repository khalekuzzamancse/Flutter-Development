import 'package:get/get.dart';
import '../../../../core/misc/logger.dart';
import '../../../chat/data/entity/peer_entity.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../di/global_controller.dart';
import 'contact_loader.dart';
import 'contact_decorator.dart';

//@formatter:off
class ContactSelectionController extends GetxController {
  final className = 'ContactSelectionController';
  var allContact = <ContactDecorator>[].obs;
  var isLoading = false.obs;
  // Observable list for selected contacts
  var selectedContacts = <ContactModel>[].obs;
  final List<ContactModel> initialContract;
  var _fetchedList=<ContactDecorator>[];


  void onLocalSearch(String query){
    final tag='$className::onLocalSearch';
    if(query.isNotEmpty){
      final filtered=allContact.where((contact) {
        final model=contact.model;
        var shouldFilter=model.name.toLowerCase().contains(query.toLowerCase());
        final profile=model.profile;
        if(profile!=null){
          shouldFilter=shouldFilter||profile.phone.toLowerCase().contains(query.toLowerCase());
        }
        return shouldFilter;
      }).toList();
      // Logger.temp(tag, 'query:$query,$filtered:$filtered');
      allContact.clear();
      allContact.addAll(filtered);
      allContact.refresh();
      _notifyObserver();
    }
    else{
      allContact.clear();
      allContact.addAll(_fetchedList);
      allContact.refresh();
      _notifyObserver();
    }
  }
  ContactSelectionController({required this.initialContract}){
    isLoading.value=true;
    final tag='$className:InitialContact';

    final decorators = initialContract
        .map((model) => ContactDecorator.fromModel(model))
        .toList();
    _fetchedList=decorators;
   // contacts.clear();
    allContact.addAll(decorators);
    allContact.refresh();
    isLoading.value=false;
    _notifyObserver();
  }

  List<int> getSelectedContactIds()=>selectedContacts.map((contact)=>contact.id).toList();



  void makeSelected(ContactModel model) {
    final tag = '$className::makeSelected()';
    //Accessing Index that why safe to use catch exception, though theoretically it can causes exception when index==-1
    //but in practise never index=-1 because user will click a that is exits
    try {

      ///TODO:Though time complexity is O(n) but in reality n is very small at worst case n=1000>
      ///means add 1000 member to the group at a time
      ///However if need improve search,insertion less than O(n) then use to  tree
      ///based data structure or it implementer(such as Map,Set)
      final clickedIndex = allContact.indexWhere((contact) => contact.model.id == model.id);
      final clickedContact=allContact[clickedIndex].model; //Have a chance to throw exception
      final isAlreadySelected=selectedContacts.contains(clickedContact);
      if (!isAlreadySelected) {
        selectedContacts.add(clickedContact);
        selectedContacts.refresh();
        //Apply changes to the AllContact:Mark as selected
         final indexInAllContact = allContact.indexWhere((contact) => contact.model.id == model.id);
         final updated=allContact[indexInAllContact].copyWith(isSelected: true);
         allContact[indexInAllContact]=updated;
         allContact.refresh();
      }

    }
    catch (e,trace) {
      Logger.errorWithTrace(tag, trace);
    }
    isLoading.value = false;
    _notifyObserver();
  }
  void _notifyObserver(){
    isLoading.value = true;
    isLoading.value = false;
  }

  void removeSelected(ContactModel model) {
    final tag = '$className::makeSelected()';
    //Accessing Index that why safe to use catch exception, though theoretically it can causes exception when index==-1
    //but in practise never index=-1 because user will click a that is exits
    try{
      final clicked = allContact.indexWhere((contact) => contact.model.id == model.id);

      allContact[clicked].copyWith(isSelected: false); //mark as unselected
        if (selectedContacts.any((contact) => contact.id == model.id)) {
          selectedContacts.removeWhere((contact) => contact.id == model.id);
          selectedContacts.refresh();
          //Apply changes to the AllContact:Mark as selected
          final indexInAllContact = allContact.indexWhere((contact) => contact.model.id == model.id);
          final updated=allContact[indexInAllContact].copyWith(isSelected: false);
          allContact[indexInAllContact]=updated;
          allContact.refresh();
        }
    }
    catch(e,trace){
      Logger.errorWithTrace(tag, trace);
    }

  }


  @override
  void onInit() {
    super.onInit();
    //loadContacts();
  }
}
