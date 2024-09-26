import 'package:flutter/material.dart';

class ProfilePost extends StatefulWidget {
  const ProfilePost({
    required this.username,
    required this.userImage,
    super.key,
  });

  final String username;
  final String userImage;
  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  Widget buildImage() {
    final dynamic image = widget.userImage != ''
        ? NetworkImage(widget.userImage)
        : const NetworkImage(
            'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png');
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildImage(),
          const SizedBox(
            width: 10,
          ),
          Text(widget.username),
        ],
      ),
    );
  }
}
