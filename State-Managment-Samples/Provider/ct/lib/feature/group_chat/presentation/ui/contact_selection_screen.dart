import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/contact_decorator.dart';
import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/contact_selection_controller.dart';
import '../../../../core/ui/search_decorator.dart';
import '../../../../../core/ui/app_color.dart';
import '../../../../../core/ui/misc.dart';
import '../../../../../core/ui/spacer.dart';
import '../../../contact_list/domain/model/contact_model.dart';
import '../../../contact_list/presentation/core.dart';

class ContactSelectionScreen extends StatefulWidget {
  final String title,subtitle;
  final List<ContactModel> initialContacts;
  late final ContactSelectionController controller;
  final Function(List<ContactModel>) onNextClick;
  /// Callback for when reaching the end
  final VoidCallback onEnd;
  ContactSelectionScreen({super.key, required this.title, required this.subtitle,
    required this.onNextClick, required this.initialContacts, required this.onEnd}){
     controller= ContactSelectionController(initialContract:initialContacts);
   }

  @override
  ContactSelectionScreenState createState() => ContactSelectionScreenState();
}

class ContactSelectionScreenState extends State<ContactSelectionScreen> {
  bool _isSearchActive = false;
  late ContactSelectionController controller;
  @override
  void initState() {
    super.initState();
    controller = ContactSelectionController(initialContract: widget.initialContacts);
  }


  @override
  Widget build(BuildContext context) {
     // final  controller=widget.controller;
    return _isSearchActive ?
    Obx((){

      final contacts = controller.allContact;
      final selected= controller.selectedContacts;
      for(var contact in contacts){

      }
      return    Scaffold(
        body: SearchDecorator(
          content: ContactListBody(
            onNextClick: (){
              widget.onNextClick(controller.selectedContacts);
            },
            onEnd: widget.onEnd,
            models: contacts,
            selected: selected,
            onClick: controller.makeSelected,
            onRemoveRequest: controller.removeSelected,
          ),
          hint: 'Type to search...',
          backgroundColor: Colors.blueGrey[50]!,
          iconColor: Colors.blue,
          hintColor: Colors.blueGrey,
          onQuery: controller.onLocalSearch,
          onBack: () {
            setState(() {
              _isSearchActive = false;
            });

          },
        ),
      );
    })
        : Obx(() {
      final allContact = controller.allContact;
      final selectedContact= controller.selectedContacts;
      for(var contact in allContact){

      }
      return _ContactSelector(
        onEnd: widget.onEnd,
        onNextClick: (){
          widget.onNextClick(controller.selectedContacts);
        },
        title: widget.title,
        subtitle: widget.subtitle,
        models: allContact,
        onClick: controller.makeSelected,
        onRemoveRequest: controller.removeSelected,
        selected:selectedContact,
        onSearchClick: () {
          setState(() {
            _isSearchActive = true;
          });
        },

      );
    });
  }
}


class _ContactSelector extends StatelessWidget {
  final VoidCallback onNextClick;
  final List<ContactDecorator> models;
  final List<ContactModel> selected;
  final VoidCallback? onSearchClick;
  final Function(ContactModel model) onClick, onRemoveRequest;
  final String title,subtitle;
  /// Callback for when reaching the end
  final VoidCallback onEnd;

  const _ContactSelector({super.key,
    this.onSearchClick,
    this.models = const [],
    required this.onClick,
    required this.selected,
    required this.onRemoveRequest, required this.title, required this.subtitle, required this.onNextClick, required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _TopBar(
        title: title,
        subtitle: subtitle,
        onBackPressed: () {
          Navigator.pop(context);
        },
        onSearchPressed: onSearchClick,
      ),
      body: ContactListBody(
        models: models,
        onEnd: onEnd,
        selected: selected,
        onClick: onClick,
        onRemoveRequest: onRemoveRequest,
        onNextClick: onNextClick,
      ),
    );
  }
}


class ContactListBody extends StatelessWidget {
  final List<ContactDecorator> models;
  final List<ContactModel> selected;
  final Function(ContactModel model) onClick;
  final Function(ContactModel model) onRemoveRequest;
  final VoidCallback onNextClick;
  /// Callback for when reaching the end
  final VoidCallback onEnd;
  const ContactListBody({
    Key? key,
    required this.models,
    required this.selected,
    required this.onClick,
    required this.onRemoveRequest,
    required this.onNextClick, required this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SelectedContact(
              models: selected,
              onRemoveRequest: onRemoveRequest,
            ),
            if(selected.isNotEmpty)
              const Divider(),
            const SpacerVertical8(),
            Expanded(
              child: _Contacts(
                onEnd:onEnd ,
                models: models,
                onClick: onClick,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: AppColor.primary,
            shape: const CircleBorder(),
            onPressed: onNextClick,
            child: const Icon(
              color: Colors.white,
              Icons.arrow_forward,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchPressed;
  final VoidCallback? onBackPressed;
  final String title,subtitle;

  const _TopBar({
    Key? key,
    this.onSearchPressed,
    this.onBackPressed, required this.title, required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      title:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: onSearchPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewContactOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const NewContactOption({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
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
        style: const TextStyle(color: AppColor.headingText, fontSize: 17),
      ),
      onTap: onTap,
    );
  }
}



class _SelectedContact extends StatelessWidget {
  final List<ContactModel> models;
  final Function(ContactModel model) onRemoveRequest;

  const _SelectedContact({required this.models, required this.onRemoveRequest});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,  // Horizontal spacing between the items
      runSpacing: 4.0,  // Vertical spacing between the lines
      children: models.map((model) {
        return Column(
          children: [
            AvatarStrategy(
              avatarUrl: model.avatarUrl??'',
              status:  CrossIcon(
                onTap: (){
                  onRemoveRequest(model);
                },
              ),  // Assuming model has avatarUrl property
            ),
            const SpacerVertical8(),
            Text(model.name.split(' ')[0]) //Show the first name only
          //  Text(model.name)
          ],
        );
      }).toList(),
    );
  }
}



///Parent must give bound height to avoid render issue.
///If parent want to give remaining height then use Expanded/Flexible
class _Contacts extends StatefulWidget {
  final List<ContactDecorator> models;
  final Function(ContactModel model) onClick;
  /// Callback for when reaching the end
  final VoidCallback onEnd;

  ///See the uses guide on doc comment to avoid unwanted behavior
  const _Contacts({required this.models, required this.onClick, required this.onEnd});

  @override
  State<_Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<_Contacts> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Add listener to detect when scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        // Reached the bottom
        widget.onEnd();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          //TODO:to provide bound height=remaining parent height otherwise causes infinite height
          child: ListView.builder(
            controller: _scrollController, // Attach the scroll controller
            itemCount: widget.models.length,
            itemBuilder: (context, index) {
              final decorator = widget.models[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () => {widget.onClick(decorator.model)},
                  child: ContactItem(
                      model: decorator.model, isSelected: decorator.isSelected),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snowchat_ios/core/ui/loading_overlay.dart';
// import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/contact_decorator.dart';
// import 'package:snowchat_ios/feature/group_chat/presentation/presentationLogic/contact_selection_controller.dart';
// import '../../../core/ui/search_decorator.dart';
// import '../../../../core/ui/resource_factory.dart';
// import '../../../../core/ui/misc.dart';
// import '../../../../core/ui/spacer.dart';
// import '../../contact_list/domain/model/contact_model.dart';
// import '../../contact_list/presentation/misc.dart';
//
// class ContactSelectionScreen extends StatefulWidget {
//   final String title,subtitle;
//   final List<ContactModel> contacts;
//   final Function(List<ContactModel>) onNextClick;
//   late final ContactSelectionController controller;
//    ContactSelectionScreen({super.key, required this.title, required this.subtitle, required this.onNextClick, required this.contacts}){
//      controller=ContactSelectionController(initialContract:contacts);
//   }
//   @override
//   ContactSelectionScreenState createState() => ContactSelectionScreenState();
// }
//
// class ContactSelectionScreenState extends State<ContactSelectionScreen> {
//   bool _isSearchActive = false;
//
//   @override
//   Widget build(BuildContext context) {
//   final  controller=widget.controller;
//      return _isSearchActive ?
//           Obx((){
//             final cons = controller.contacts;
//             final selected= controller.selectedContacts;
//             for(var contact in cons){
//
//             }
//             return    Scaffold(
//               body: SearchDecorator(
//                 content: ContactListBody(
//                   onNextClick: (){
//                     widget.onNextClick(controller.selectedContacts);
//                   },
//                   models: cons,
//                   selected: selected,
//                   onClick: controller.makeSelected,
//                   onRemoveRequest: controller.removeSelected,
//                 ),
//                 hint: 'Type to search...',
//                 backgroundColor: Colors.blueGrey[50]!,
//                 iconColor: Colors.blue,
//                 hintColor: Colors.blueGrey,
//                 onQuery: (query) {
//
//                 },
//                 onBack: () {
//                   setState(() {
//                     _isSearchActive = false;
//                   });
//
//                 },
//               ),
//             );
//       })
//         : Obx(() {
//             final cons = controller.contacts;
//             final selected= controller.selectedContacts;
//             final isLoading=controller.isLoading.value;
//             for(var contact in cons){
//
//             }
//             return LoadingOverlay(isLoading: isLoading, content: _ContactSelector(
//               onNextClick: (){
//                 widget.onNextClick(controller.selectedContacts);
//               },
//               title: widget.title,
//               subtitle: widget.subtitle,
//               models: cons,
//               onClick: controller.makeSelected,
//               onRemoveRequest: controller.removeSelected,
//               selected: selected,
//               onSearchClick: () {
//                 setState(() {
//                   _isSearchActive = true;
//                 });
//               },
//             ));
//           });
//   }
// }
//
//
// class _ContactSelector extends StatelessWidget {
//   final VoidCallback onNextClick;
//   final List<ContactDecorator> models;
//   final List<ContactModel> selected;
//   final VoidCallback? onSearchClick;
//   final Function(ContactModel model) onClick, onRemoveRequest;
//   final String title,subtitle;
//
//   const _ContactSelector({super.key,
//     this.onSearchClick,
//     this.models = const [],
//     required this.onClick,
//     required this.selected,
//     required this.onRemoveRequest, required this.title, required this.subtitle, required this.onNextClick,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _TopBar(
//         title: title,
//         subtitle: subtitle,
//         onBackPressed: () {
//           Navigator.pop(context);
//         },
//         onSearchPressed: onSearchClick,
//       ),
//       body: ContactListBody(
//         models: models,
//         selected: selected,
//         onClick: onClick,
//         onRemoveRequest: onRemoveRequest,
//         onNextClick: onNextClick,
//       ),
//     );
//   }
// }
//
//
// class ContactListBody extends StatelessWidget {
//   final List<ContactDecorator> models;
//   final List<ContactModel> selected;
//   final Function(ContactModel model) onClick;
//   final Function(ContactModel model) onRemoveRequest;
//   final VoidCallback onNextClick;
//
//   const ContactListBody({
//     Key? key,
//     required this.models,
//     required this.selected,
//     required this.onClick,
//     required this.onRemoveRequest,
//     required this.onNextClick,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _SelectedContact(
//               models: selected,
//               onRemoveRequest: onRemoveRequest,
//             ),
//             if(selected.isNotEmpty)
//               const Divider(),
//             const SpacerVertical8(),
//             Expanded(
//               child: _Contacts(
//                 models: models,
//                 onClick: onClick,
//               ),
//             ),
//           ],
//         ),
//         Positioned(
//           bottom: 16.0,
//           right: 16.0,
//           child: FloatingActionButton(
//             backgroundColor: AppColor.primary,
//             shape: const CircleBorder(),
//             onPressed: onNextClick,
//             child: const Icon(
//               color: Colors.white,
//               Icons.arrow_forward,
//               size: 24,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
// class _TopBar extends StatelessWidget implements PreferredSizeWidget {
//   final VoidCallback? onSearchPressed;
//   final VoidCallback? onBackPressed;
//   final String title,subtitle;
//
//   const _TopBar({
//     Key? key,
//     this.onSearchPressed,
//     this.onBackPressed, required this.title, required this.subtitle,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColor.primary,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: onBackPressed,
//       ),
//       title: const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "New Group",
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//           Text(
//             "Add Members",
//             style: TextStyle(
//                 color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search, color: Colors.white),
//           onPressed: onSearchPressed,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// class NewContactOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
//
//   const NewContactOption({
//     Key? key,
//     required this.icon,
//     required this.label,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: AppColor.primary,
//         child: Icon(icon, color: Colors.white),
//       ),
//       title: Text(
//         label,
//         style: const TextStyle(color: AppColor.headingText, fontSize: 17),
//       ),
//       onTap: onTap,
//     );
//   }
// }
//
//
//
// class _SelectedContact extends StatelessWidget {
//   final List<ContactModel> models;
//   final Function(ContactModel model) onRemoveRequest;
//
//   const _SelectedContact({required this.models, required this.onRemoveRequest});
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8.0,  // Horizontal spacing between the items
//       runSpacing: 4.0,  // Vertical spacing between the lines
//       children: models.map((model) {
//         return Column(
//           children: [
//             AvatarStrategy(
//               avatarUrl: model.avatarUrl??'',
//               status:  CrossIcon(
//                 onTap: (){
//                   onRemoveRequest(model);
//                 },
//               ),  // Assuming model has avatarUrl property
//             ),
//             const SpacerVertical8(),
//             Text(model.name)
//           ],
//         );
//       }).toList(),
//     );
//   }
// }
//
//
//
// ///Parent must give bound height to avoid render issue.
// ///If parent want to give remaining height then use Expanded/Flexible
// class _Contacts extends StatelessWidget {
//   final List<ContactDecorator> models;
//   final Function(ContactModel model) onClick;
//
//   ///See the uses guide on doc comment to avoid unwanted behavior
//   const _Contacts({required this.models, required this.onClick});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           //TODO:to provide bound height=remaining parent height otherwise causes infinite height
//           child: ListView.builder(
//             itemCount: models.length,
//             itemBuilder: (context, index) {
//               final decorator = models[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: GestureDetector(
//                   onTap: () => {onClick(decorator.model)},
//                   child: ContactItem(
//                       model: decorator.model, isSelected: decorator.isSelected),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
