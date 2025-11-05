// @formatter:off
import 'package:flutter/material.dart';
//@formatter:off
class UserShortInfo extends StatefulWidget {
  const UserShortInfo({Key? key, required this.username, required this.avatarLink, required this.onUserProfileRequest,}) : super(key: key);

  @override
  _UserShortInfoState createState() => _UserShortInfoState();


  final String username, avatarLink;
  final VoidCallback onUserProfileRequest;
}

//@formatter:off
class _UserShortInfoState extends State<UserShortInfo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    final labelColor = style?.color;
    final labelStyle = style?.copyWith(color: labelColor?.withOpacity(_isHovered ? 1.0 : 0.6));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onUserProfileRequest,
        child: Row(children: [
            ClipOval(
              child: AnimatedScale(scale: _isHovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 150),
                child: Image.network(widget.avatarLink, width: 30, height: 30, fit: BoxFit.cover),
              ),
            )
          ,const SizedBox(width: 8)
          , AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: labelStyle ?? const TextStyle(),
              child: Text(widget.username),
            ),
          ],
        ),
      ),
    );
  }

}

// class UserShortInfo extends StatelessWidget {
//   const UserShortInfo({Key? key,
//     required this.username,
//     required this.avatarLink,
//     required this.onUserProfileRequest})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final style = Theme.of(context).textTheme.labelMedium;
//     final labelColor = style?.color;
//     final labelStyle = style?.copyWith(color: labelColor?.withOpacity(0.6));
//
//     final factory = ComposableFactory.instance;
//     final row = factory.row();
//     final asyncImage = factory.asyncImage();
//
//     return row
//         .append(
//         child: asyncImage.link(avatarLink).build(),
//         modifier: Modifier().clipCircular(30).clickable(onUserProfileRequest))
//         .spacer(8)
//         .append(
//         child:Text(username, style: labelStyle),
//         modifier: Modifier().clickable(onUserProfileRequest))
//         .build();
//   }
//
//   final String username;
//   final String avatarLink;
//   final VoidCallback onUserProfileRequest;
// }