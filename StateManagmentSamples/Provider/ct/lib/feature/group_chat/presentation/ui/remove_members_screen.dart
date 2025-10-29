import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'contact_selection_screen.dart';
import '../presentationLogic/remove_member_controller.dart';

//@formatter:off
class RemoveMemberToGroupScreen extends StatelessWidget {
  final int conversationId;
  late final   controller=RemoveMemberController(conversationId);

  RemoveMemberToGroupScreen({super.key, required this.conversationId}){
    controller.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return  Obx((){
      final isLoading=controller.isLoading.value;
      final contacts=controller.contacts;
      if(!isLoading){
        return ContactSelectionScreen(
          onEnd: controller.onEnd,
            title: 'Contacts',
            subtitle: '',
            initialContacts: contacts,
            onNextClick: (contacts) async{
              final ids=contacts.map((contact)=>contact.id).toList();
             await  controller.remove(ids);
              if(context.mounted){
                Navigator.pop(context);
              }
            });
      }
      else{
        return   const Scaffold(body: Center(child: SizedBox(width:64,height:64,child: CircularProgressIndicator())));
      }

    });
  }
}
