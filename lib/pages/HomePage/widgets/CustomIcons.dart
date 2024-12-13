import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final double size;
  final Color color;

  CustomIconWidget({
    Key? key,
    required this.icon,
    required this.name,
    this.size = 50.0,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: size / 2,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ],
    );
  }
}
