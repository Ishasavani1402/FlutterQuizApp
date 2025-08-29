import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../UserAuth/Login.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:  Duration(seconds: 4),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    checkuser();
  }

  // Asynchronously navigate to the next screen.
  Future<void> checkuser() async {
    // Wait for the animation to finish plus a small buffer.
    await Future.delayed(Duration(milliseconds: 2000));
    // Use `pushReplacement` to prevent the user from navigating back to the splash screen.
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homescreen()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
    }
  }

  @override
  void dispose() {
    // It's important to dispose of the animation controller to prevent memory leaks.
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Use a more dynamic, visually appealing gradient.
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1C3D24), // A nice shade of purple
              Color(0xff88ab8e), // A darker shade of purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Use FadeTransition to apply the animation to the content.
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Quiz logo or icon. You can replace this with your own asset.
                // The `Transform.scale` makes the logo slightly pulse during the animation.
                Transform.scale(
                  scale: 1.0 + (_animation.value * 0.1), // Scales from 1.0 to 1.1
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.lightbulb,
                      size: 70,
                      color: Color(0xFF21482A),
                    ),
                  )
                ),
                SizedBox(height: 24),
                // App title. Using GoogleFonts for a professional touch.
                Text(
                  'Quiz Master',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // A brief slogan or subtitle.
                Text(
                  'Test Your Knowledge!',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}