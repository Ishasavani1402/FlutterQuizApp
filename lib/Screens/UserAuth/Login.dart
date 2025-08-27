import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapplication/Screens/HomePage.dart';

import 'ForgotPassword.dart';
import 'Registration.dart';


class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // A key to uniquely identify our form and enable validation.
  final _formKey = GlobalKey<FormState>();

  bool obcurse = true;

  Future<void> login()async{
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email and Password!!",style:
      TextStyle(color: Colors.black),),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.yellow,));
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text).then((onValue){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage()));
      });
      print("login email " + _emailController.text);
      print("login password " +_passwordController.text);
      print("Login Sucessfully!!!");
    }on FirebaseAuthException catch(e){
      print("Error for Login : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text("Error : ${e.message}"))));


    }

  }

  Future<bool> googlelogin()async{
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'], // Specify scopes if needed
      );
      //sign in with google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser!=null){
        print("Google Sign-In Successful");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In Successful")),
        );
      }

      if(googleUser == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In was cancelled")),
        );
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      //create credential for firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser!=null;
    }on FirebaseAuthException catch(e){
      print("Error for Login : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text("Error : ${e.message}"))));
    }
    return false;

  }

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
                    'Welcome Back!',
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
                    controller: _emailController,
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

                  // Password Text Field.
                  TextFormField(
                    controller: _passwordController,
                    obscureText: obcurse, // Hides the password input.
                    style:  TextStyle(color: Color(0xFF483D8B)),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:  Icon(
                        Icons.lock,
                        color: Color(0xFF483D8B),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          obcurse = !obcurse;
                        });
                      }, icon: obcurse ? Icon(Icons.visibility_off) :
                      Icon(Icons.visibility)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                  ),
                  SizedBox(height: 24),

                  // login Button.
                  ElevatedButton(
                    onPressed: login,
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
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Forgotpassword()));
                      }, child: Text("Forgot Password" , style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.white
                      ),))
                    ],
                  ),
                  // Optional: Login link for users who already have an account.
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    child:  Text(
                      "Don't Have an Account?? Register",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey, // Customize the color
                          height: 36, // Adjust the vertical spacing
                          thickness: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey, // Customize the color
                          height: 36, // Adjust the vertical spacing
                          thickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  //continue with google
                  ElevatedButton(onPressed: ()async{
                    bool islogin = await googlelogin();
                    if(islogin){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error in Login")));
                    }

                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 10),
                      Text("Continue with Google")
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

