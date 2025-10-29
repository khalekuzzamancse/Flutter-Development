import 'package:flutter/material.dart';

class AvatarSelectable extends StatelessWidget {
  final String avatarUrl;
  final bool isSelected;

  const AvatarSelectable({
    Key? key,
    required this.avatarUrl,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarStrategy(
      status: isSelected ? const SelectedIcon()
          : const SizedBox.shrink(),
      avatarUrl: avatarUrl,
    );
  }
}

class CrossIcon extends StatelessWidget {
  final VoidCallback onTap;

  const CrossIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.cancel,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}


class SelectedIcon extends StatelessWidget {
  const SelectedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: const BoxDecoration(
        color: Color(0xFF48F063),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        size: 16,
        color: Colors.white,
      ),
    );
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
