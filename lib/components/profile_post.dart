import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

import '../constant/color.dart';

class ProfilePost extends StatefulWidget {
  const ProfilePost({
    required this.user,
    super.key,
  });

  final User user;
  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  Widget buildImage() {
    final dynamic image = widget.user.imageUrl != ''
        ? NetworkImage(widget.user.imageUrl)
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
          SizedBox(width: 10,),
          Text(widget.user.username),
        ],
      ),
    );
  }
}
