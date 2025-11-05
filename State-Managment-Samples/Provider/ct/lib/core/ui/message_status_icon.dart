import 'package:flutter/material.dart';

class MessageStatusIcon extends StatelessWidget {
  final int status;
  const MessageStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if(status==0){
      return const Icon(
        Icons.done,
        size: 16.0,
        color:Colors.grey,
      );
    }
    if(status==1){
      return const Icon(
        Icons.done_all_outlined,
        size: 16.0,
        color:Colors.grey,
      );
    }
    if(status==2){
      return const Icon(
        Icons.done_all_outlined,
        size: 16.0,
        color:Colors.blue,
      );
    }
    return const SizedBox.shrink();
  }
}