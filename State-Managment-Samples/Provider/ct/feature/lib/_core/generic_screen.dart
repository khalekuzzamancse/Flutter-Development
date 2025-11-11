

import 'package:flutter/material.dart';

import '../chat/app_color.dart';

///Has top bar with back navigation
class GenericScreen extends StatelessWidget {
  final String title;
  final Widget content;

  const GenericScreen(
      {Key? key,
        this.title='',
        required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _TopBar(
        title: title,
        onBackArrowClick: () {
          Navigator.pop(context);
        },
      ),
      body:content,
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  ///Name such as Setting, Help, etc
  final String title;

  final VoidCallback onBackArrowClick;

  const _TopBar({
    Key? key,
    required this.title,
    required this.onBackArrowClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBackArrowClick,
        ),
        title:Text(title,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25))
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GenericAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onClick;

  const GenericAction({
    Key? key,
    required this.icon,
    required this.label,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColor.primary,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: AppColor.headingText
        ),
      ),
      onTap: onClick,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    );
  }
}