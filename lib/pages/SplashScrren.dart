import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitap/pages/HomePage/Nav_page.dart';
import 'package:vitap/pages/LoginPage.dart'; // Assuming GetX is used for navigation

class SplashScreen extends StatefulWidget {
  bool? isLogin;
  SplashScreen({required this.isLogin});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Animation Duration
    );

    // Fade animation from 0 to 1 (transparent to visible)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Scale animation from 0.8 to 1.0 (slightly zoom in)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.off(() => widget.isLogin!
              ? NavPage()
              : LoginPage()); // Assuming GetX is used for navigation
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value, // Fades in
              child: Transform.scale(
                scale: _scaleAnimation.value, // Scales in
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Vit-AP" with Typewriter animation
              SizedBox(
                height: 100,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 70.0, // Large font size
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Customize the color
                    letterSpacing: 2.0, // Stylish spacing
                    fontFamily: 'Pacifico', // Use a stylish font
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Vit-AP',
                        speed:
                            const Duration(milliseconds: 200), // typing speed
                        cursor: '|', // Cursor for the typewriter effect
                      ),
                    ],
                    isRepeatingAnimation: false, // Stops after first display
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between Vit-AP and subtitle
              Text(
                'Vellore Institute Of Technology',
                style: TextStyle(
                  fontSize: 20.0, // Subtitle font size
                  fontWeight: FontWeight.w400,
                  color: Colors.black54, // Lighter color for subtitle
                  letterSpacing: 1.5,
                  fontFamily: 'Roboto', // Another simple font for subtitle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
