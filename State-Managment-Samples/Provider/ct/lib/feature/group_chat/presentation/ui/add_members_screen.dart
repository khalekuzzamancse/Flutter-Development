//@formatter:off
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/add_member_controller.dart';
import 'contact_selection_screen.dart';

class AddNewMemberToGroupScreen extends StatelessWidget {
  final int conversationId;
  late final AddMemberController controller;
  AddNewMemberToGroupScreen({super.key, required this.conversationId}){
    controller=AddMemberController(conversationId);
    controller.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return  Obx((){
      final isLoading=controller.isLoading.value;
      final contacts=controller.contacts;
      if(!isLoading){
        return ContactSelectionScreen(
          onEnd: (){},
            title: 'Contacts',
            subtitle: '',
            initialContacts: contacts,
            onNextClick: (contacts) async{
              final ids=contacts.map((contact)=>contact.id).toList();
            await controller.add(ids);
             if(context.mounted){
               Navigator.pop(context);
             }

            });
      }
      else{
        return    const Scaffold(body: Center(child: SizedBox(width:64,height:64,child: CircularProgressIndicator())));
      }
    });
  }
}