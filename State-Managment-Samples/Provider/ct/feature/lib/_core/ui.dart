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


class AvatarWithStatus extends StatelessWidget {
  final String avatarUrl;
  final bool onOnline;

  const AvatarWithStatus({
    Key? key,
    required this.avatarUrl,
    required this.onOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarStrategy(
      status:StatusIcon(isActive: onOnline),
      avatarUrl: avatarUrl,
    );
  }
}
class AvatarWithStatus2 extends StatelessWidget {
  final String avatarUrl;

  const AvatarWithStatus2({Key? key, required this.avatarUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarStrategy(
      status: const SizedBox.shrink(),
      avatarUrl: avatarUrl,
    );
  }
}
class StatusIcon extends StatelessWidget {
  final bool isActive;

  const StatusIcon({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }
}

class AvatarStrategy extends StatelessWidget {
  final String avatarUrl;
  final Widget status;

  const AvatarStrategy({
    Key? key,
    required this.avatarUrl,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 24.0,
          ),
          Positioned(
            right: -6, // Adjust to ensure the icon is correctly placed
            top: 18, // Center vertically on the avatar
            child: status,
          ),
        ],
      ),
    );
  }
}

// extension NavigationRelated on BuildContext {
//   void push(Widget route) {
//     Navigator.push(
//       this,
//       MaterialPageRoute(builder: (_) => route),
//     );
//   }
// }
