import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapplication/Screens/MainScreens/CategoryScreen.dart';
import '../../Database/DB_Helper.dart';
import '../UserAuth/Login.dart';
import 'Rules.dart';

Color kPrimaryColor = Color(0xFF2A4931);
Color kAccentColor = Color(0xff88ab8e);

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      }
    } catch (e) {
      print("Error while logout: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchQuizHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await DatabaseHelper.instance.getQuizHistory(user.uid);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _fetchQuizAnswers(int attemptId) async {
    return await DatabaseHelper.instance.getQuizAnswers(attemptId);
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold,
          color: Color(0xFF142B1A))),
          content: Text('Are you sure you want to log out?', style: GoogleFonts.poppins(
            color: Color(0xFF142B1A)
          )),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: GoogleFonts.poppins(color: kPrimaryColor, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Yes', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  String getDisplayName(User? user) {
    if (user == null) return 'User';
    // Prioritize displayName from Google Sign-In
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    // Fallback to username from email
    final email = user.email ?? 'User';
    return email.split('@')[0]; // Extract part before '@'
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor,
              Color(0xFF142B1A)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Custom Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: screenHeight * 0.08,
                  bottom: screenHeight * 0.03,
                  left: screenWidth * 0.06,
                  right: screenWidth * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF142B1A),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome,",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            getDisplayName(user),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _showLogoutDialog,
                      icon: Icon(Icons.logout, color: Colors.white),
                      iconSize: screenWidth * 0.07,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              // Main Content Area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buttons for Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              foregroundColor: Color(0xFF142B1A),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                              shadowColor: Colors.black.withOpacity(0.4),
                            ),
                            child: Text(
                              "Start Quiz",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Rules()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              foregroundColor: Color(0xFF142B1A),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                              shadowColor: Colors.black.withOpacity(0.4),
                            ),
                            child: Text(
                              "Rules",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Quiz History",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Divider(color: Colors.white38, thickness: 1.5, height: 20),
                  ],
                ),
              ),
              // Scrollable Quiz History Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchQuizHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: kAccentColor));
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "No quiz history available",
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      final history = snapshot.data!;
                      return ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final attempt = history[index];
                          final date = DateTime.parse(attempt['attempt_date']);
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Card(
                              color: kAccentColor.withOpacity(0.95),
                              elevation: 6,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              child: ExpansionTile(
                                leading: Icon(Icons.history_edu, color: kPrimaryColor, size: 30),
                                title: Text(
                                  attempt['category_name'],
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold, color: Color(0xFF142B1A)),
                                ),
                                subtitle: Text(
                                  "${date.day}/${date.month}/${date.year}",
                                  style: GoogleFonts.poppins(color: kPrimaryColor.withOpacity(0.8)),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Score: ${attempt['correct_answers']} / ${attempt['total_questions']}",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: kPrimaryColor),
                                        ),
                                        SizedBox(height: 8),
                                        FutureBuilder<List<Map<String, dynamic>>>(
                                          future: _fetchQuizAnswers(attempt['attempt_id']),
                                          builder: (context, answerSnapshot) {
                                            if (answerSnapshot.connectionState == ConnectionState.waiting) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
                                              );
                                            } else if (answerSnapshot.hasError || !answerSnapshot.hasData) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "No answers available",
                                                  style: GoogleFonts.poppins(color: kPrimaryColor.withOpacity(0.8)),
                                                ),
                                              );
                                            }
                                            final answers = answerSnapshot.data!;
                                            return Column(
                                              children: answers.map((answer) {
                                                bool isCorrect = answer['is_correct'] == 1;
                                                return ListTile(
                                                  visualDensity: VisualDensity.compact,
                                                  leading: Icon(
                                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                                    color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                                                  ),
                                                  title: Text(
                                                    answer['question'],
                                                    style: GoogleFonts.poppins(fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.w500),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Your Answer: ${answer['user_answer'] ?? 'Not answered'}",
                                                        style: GoogleFonts.poppins(fontSize: 12, color: kPrimaryColor.withOpacity(0.9)),
                                                      ),
                                                      Text(
                                                        "Correct Answer: ${answer['correct_answer']}",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: isCorrect ? kPrimaryColor.withOpacity(0.9) : Colors.red.shade800,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}

