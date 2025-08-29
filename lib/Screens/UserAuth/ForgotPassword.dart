import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

// Use the color codes provided by the user.
const Color kPrimaryColor = Color(0xFF1C3D24);
const Color kAccentColor = Color(0xff88ab8e);

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController _emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> forgotpassword() async {
    if (_emailcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please Enter Email for reset password!!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
     await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailcontroller.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password reset link sent to your email!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } on FirebaseAuthException catch (e) {
      print("Error for Login : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error: ${e.message}",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, Color(0xFF142B1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Text(
                          "Enter your email to receive a password reset link.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        TextFormField(
                          controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(color: kPrimaryColor),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: GoogleFonts.poppins(
                                color: kPrimaryColor.withOpacity(0.6)),
                            filled: true,
                            fillColor: kAccentColor.withOpacity(0.2),
                            prefixIcon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              const BorderSide(color: kPrimaryColor, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        ElevatedButton(
                          onPressed: forgotpassword,
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
                            'Reset Password',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  Login()),
                            );
                          },
                          child: Text(
                            "Back to Login",
                            style: GoogleFonts.poppins(
                                color: kPrimaryColor.withOpacity(0.8),
                                fontSize: 16),
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