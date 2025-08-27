import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController _emailcontroller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> forgotpassword()async{
    if(_emailcontroller.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email for reset password!!",style:
      TextStyle(color: Colors.black),),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.yellow,));
    }
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailcontroller.text);
      print("Reset Password Sucessfully!!!");
    }on FirebaseAuthException catch(e){
      print("Error for Login : $e");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a gradient background for a visually appealing look.
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF483D8B), // A dark purple
              Color(0xFF6A5ACD), // A lighter purple
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Title or Logo.
                  Text(
                    'Reset Password!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 48),

                  // Email Text Field.
                  TextFormField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    style:  TextStyle(color: Color(0xFF483D8B)),
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:  Icon(
                        Icons.email,
                        color: Color(0xFF483D8B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                  ),
                  SizedBox(height: 16),

                  // login Button.
                  ElevatedButton(
                    onPressed: forgotpassword,
                    style: ElevatedButton.styleFrom(
                      foregroundColor:  Color(0xFF483D8B),
                      backgroundColor: Colors.white,
                      padding:  EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child:  Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
