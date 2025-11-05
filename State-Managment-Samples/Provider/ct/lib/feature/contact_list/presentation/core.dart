import 'package:flutter/material.dart';
import 'package:snowchat_ios/core/misc/time_formatter.dart';
import 'package:snowchat_ios/feature/navigation/routes.dart';

import '../../../core/ui/app_color.dart';
import '../../../core/ui/misc.dart';
import '../domain/model/contact_model.dart';

///Parent must give bound height to avoid render issue.
///If parent want to give remaining height then use Expanded/Flexible
class NonSelectableContacts extends StatelessWidget {
  final List<ContactModel> models;
  final bool showLabel;
  final Function(ContactModel model) onClick;

  ///See the uses guide on doc comment to avoid unwanted behavior
  const NonSelectableContacts({super.key, required this.models,  this.showLabel=true,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(showLabel)
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Contact List",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
          ),
        ),
        Expanded(//TODO:to provide bound height=remaining parent height otherwise causes infinite height
          child: ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {
              final chat = models[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () => {
                    onClick(chat)
                    //Navigation.navigateToChat(chat, context)
                  },
                  child: ContactItem(model: chat),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final ContactModel model;
  final bool isSelected;

  const ContactItem({Key? key, required this.model,  this.isSelected=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneNo=  model.profile?.phone;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ContactLayoutStrategy(
        avatar:AvatarSelectable(
          avatarUrl: model.avatarUrl??'',
          isSelected: isSelected,
        ),
        name: Text(
          model.name,
          style: const TextStyle(
            color: AppColor.headingText,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        phoneNumber:  phoneNo==null?null:Text(
          model.profile?.phone??'',
          style: const TextStyle(
            color: AppColor.headingText,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
          ),
        ),
        lastSeen: Text(
          'Last seen at ${TimeFormatter.formatTimestamp(model.lastSeen??'-')}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ContactLayoutStrategy extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget? phoneNumber;
  final Widget lastSeen;


  const ContactLayoutStrategy({
    Key? key,
    required this.avatar,
    required this.name,
    required this.lastSeen,
    required this.phoneNumber
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatar,
        const SizedBox(width: 8.0), // Spacing between avatar and column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            name,
            if(phoneNumber!=null)
            const SizedBox(height: 8.0), // Spacing between name and last seen
            if(phoneNumber!=null)
            phoneNumber!,
            const SizedBox(height: 8.0),
            lastSeen,
          ],
        ),
      ],
    );
  }
}
