import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for Google Fonts

import '../MainScreens/HomeScreen.dart';
import 'Login.dart';

// Use the color codes provided by the user for a consistent theme.
const Color kPrimaryColor = Color(0xFF1C3D24);
const Color kAccentColor = Color(0xff88ab8e);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obcurse = true;

  Future<void> _registerUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please Enter Email and Password!!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit early if fields are empty
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Homescreen()),
        );
      });

      print("Registration success!!");
    } on FirebaseAuthException catch (e) {
      print("Error for registration : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
        content: Text("Error : ${e.message}", style: GoogleFonts.poppins()),
        backgroundColor: Colors.red,
      ));
    }
  }



  @override
  void dispose() {
    // It's good practice to dispose of the controllers to free up resources.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for dynamic sizing.
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Use a gradient background for a visually appealing look.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor,
              Color(0xFF142B1A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Title or Logo.
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Email Text Field.
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(color: kPrimaryColor),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: GoogleFonts.poppins(color: kPrimaryColor.withOpacity(0.6)),
                            filled: true,
                            fillColor: kAccentColor.withOpacity(0.2),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Password Text Field.
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obcurse, // Hides the password input.
                          style: GoogleFonts.poppins(color: kPrimaryColor),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: GoogleFonts.poppins(color: kPrimaryColor.withOpacity(0.6)),
                            filled: true,
                            fillColor: kAccentColor.withOpacity(0.2),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: kPrimaryColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obcurse = !obcurse;
                                });
                              },
                              icon: obcurse
                                  ? const Icon(Icons.visibility_off, color: kPrimaryColor)
                                  : const Icon(Icons.visibility, color: kPrimaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Register Button.
                        ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Optional: Login link for users who already have an account.
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>  Login()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: GoogleFonts.lato(color: kPrimaryColor.withOpacity(0.8), fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}