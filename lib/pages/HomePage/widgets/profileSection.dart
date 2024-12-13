import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/ProfileModel.dart';

class ProfileSection extends StatefulWidget {
  final ThemeController themeController;
  final ProfileModel profile;
  final String username;

  ProfileSection(
      {required this.themeController,
      required this.profile,
      required this.username});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  ImageProvider? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  @override
  void didUpdateWidget(ProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the profile image has changed, and update it
    if (oldWidget.profile.profileImageBase64 !=
        widget.profile.profileImageBase64) {
      _loadProfileImage();
    }
  }

  void _loadProfileImage() {
    if (widget.profile.profileImageBase64 != null) {
      setState(() {
        profileImage =
            MemoryImage(base64Decode(widget.profile.profileImageBase64!));
      });
    } else {
      setState(() {
        profileImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 10, right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.themeController.gradientColors[0],
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            offset: Offset(1, 2),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            backgroundImage: (profileImage != null)
                ? profileImage
                : null, // Display the cached image if available
            child: (profileImage == null)
                ? Icon(Icons.person, size: 50, color: Colors.black)
                : null, // If no image, show the default icon
          ).animate().slideY(begin: -1 / 4),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.profile.name ?? "......."}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().slideX(begin: 1),
              Text(
                widget.username ?? ".......",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ).animate().slideY(begin: 1).fade(),
            ],
          ),
        ],
      ),
    );
  }
}
