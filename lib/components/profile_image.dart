import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilie_butt_skater_app/models/user.dart';

import '../constant/color.dart';

class ProfileImagePage extends StatefulWidget {
  const ProfileImagePage({
    required this.user,
    super.key,
  });

  final User user;
  @override
  State<ProfileImagePage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImagePage> {
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
          width: 100,
          height: 100,
          child: InkWell(),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: AppColors.backgroundColor,
        all: 3.0,
        child: buildCircle(
          color: color,
          all: 8.0,
          child: const InkWell(
            child: Icon(
              Icons.edit,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({required child, required color, required all}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
        ],
      ),
    );
  }
}
