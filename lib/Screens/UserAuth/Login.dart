import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../MainScreens/HomeScreen.dart';
import 'ForgotPassword.dart';
import 'Registration.dart';

// Use the color codes provided by the user.
 Color kPrimaryColor = Color(0xFF1C3D24);
 Color kAccentColor = Color(0xff88ab8e);

class Login extends StatefulWidget {
   Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool obcurse = true;

  Future<void> login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please Enter Email and Password!!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .then((onValue) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>  Homescreen()));
      });
      print("login email " + _emailController.text);
      print("login password " + _passwordController.text);
      print("Login Sucessfully!!!");
    } on FirebaseAuthException catch (e) {
      print("Error for Login : $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: (Text("Error : ${e.message}"))));
    }
  }

  Future<bool> googlelogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        print("Google Sign-In Successful");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In Successful")),
        );
      }

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In was cancelled")),
        );
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser != null;
    } on FirebaseAuthException catch (e) {
      print("Error for Login : $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: (Text("Error : ${e.message}"))));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for dynamic sizing.
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, Color(0xFF142B1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:  EdgeInsets.symmetric(horizontal: 10.0),
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
                        Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(color: kPrimaryColor),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: GoogleFonts.poppins(
                                color: kPrimaryColor.withOpacity(0.6)),
                            filled: true,
                            fillColor: kAccentColor.withOpacity(0.2),
                            prefixIcon:  Icon(
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
                               BorderSide(color: kPrimaryColor, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obcurse,
                          style: GoogleFonts.poppins(color: kPrimaryColor),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: GoogleFonts.poppins(
                                color: kPrimaryColor.withOpacity(0.6)),
                            filled: true,
                            fillColor: kAccentColor.withOpacity(0.2),
                            prefixIcon:  Icon(
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
                                    ?  Icon(Icons.visibility_off,
                                    color: kPrimaryColor)
                                    :  Icon(Icons.visibility,
                                    color: kPrimaryColor)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                               BorderSide(color: kPrimaryColor, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                            padding:  EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>  Forgotpassword()));
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: kPrimaryColor.withOpacity(0.8)),
                                ))
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  RegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Don't Have an Account? Register",
                            style: GoogleFonts.lato(
                                color: kPrimaryColor.withOpacity(0.8), fontSize: 16),
                          ),
                        ),
                         SizedBox(height: 14),
                         Row(
                           children: [
                             Expanded(
                               child: Divider(
                                 color: Colors.grey,
                                 thickness: 1,
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
                               child: Text(
                                 'OR',
                                 style: GoogleFonts.poppins(
                                   color: kPrimaryColor,
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                             Expanded(
                               child: Divider(
                                 color: Colors.grey,
                                 thickness: 1,
                               ),
                             ),

                           ],
                         ),
                         SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () async {
                            bool islogin = await googlelogin();
                            if (islogin) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  Homescreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Error in Login")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding:  EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                          icon:  Icon(FontAwesomeIcons.google),
                          label: Text(
                            "Continue with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
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
          ),
        ),
      ),
    );
  }
}