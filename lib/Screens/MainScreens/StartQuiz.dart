import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizapplication/ApiService/ApiService.dart';
import 'package:quizapplication/Model/QUizModel.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart'; // Import for Google Fonts
import '../../Database/DB_Helper.dart';
import 'QuizResult.dart';

// Use the color codes provided by the user.
 Color kPrimaryColor = Color(0xFF1C3D24);
 Color kAccentColor = Color(0xff88ab8e);

class Startquiz extends StatefulWidget {
  final int? categoryid;
  final String? Categoryname;
  Startquiz({super.key, this.categoryid, this.Categoryname});

  @override
  State<Startquiz> createState() => _StartquizState();
}

class _StartquizState extends State<Startquiz> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int attemptedQuestions = 0;
  Timer? timer;
  int secondsRemaining = 30;
  bool isQuizCompleted = false;
  List<String?> userAnswers = [];
  List<bool> answerCorrectness = [];
  String? selectedAnswer;
  late Future<QuizModel?> quizFuture;
  List<List<String>> shuffledAnswers = [];
  int? attemptId; // Store the attempt ID

  @override
  void initState() {
    super.initState();
    quizFuture = ApiService.api_quiz(widget.categoryid!);
    // Initialize attempt in SQLite
    _initializeAttempt();
  }

  Future<void> _initializeAttempt() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await DatabaseHelper.instance.insertUser(user.uid, user.email ?? '');
      attemptId = await DatabaseHelper.instance.insertQuizAttempt(
        user.uid,
        widget.categoryid!,
        widget.Categoryname ?? 'Unknown',
      );
    }
  }

  void startTimer(QuizModel quiz) {
    timer?.cancel();
    secondsRemaining = 30;
    timer = Timer.periodic( Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (secondsRemaining > 0) {
            secondsRemaining--;
          } else {
            timer.cancel();
            moveToNextQuestion(quiz);
          }
        });
      }
    });
  }

  void moveToNextQuestion(QuizModel quiz) async {
    setState(() {
      // Handle answered or skipped questions
      if (userAnswers[currentQuestionIndex] != null) {
        // Question was answered
        attemptedQuestions++;
        bool isCorrect = userAnswers[currentQuestionIndex] == quiz.results![currentQuestionIndex].correctAnswer;
        if (isCorrect) {
          correctAnswers++;
          answerCorrectness[currentQuestionIndex] = true;
        } else {
          wrongAnswers++;
          answerCorrectness[currentQuestionIndex] = false;
        }
      } else {
        // Question was skipped
        answerCorrectness[currentQuestionIndex] = false; // Skipped questions are not correct
      }

      // Save answer to SQLite (null for skipped questions)
      DatabaseHelper.instance.insertQuizAnswer(
        attemptId!,
        quiz.results![currentQuestionIndex].question!,
        userAnswers[currentQuestionIndex] ?? 'Skipped', // Store "Skipped" for clarity
        quiz.results![currentQuestionIndex].correctAnswer!,
        userAnswers[currentQuestionIndex] != null &&
            userAnswers[currentQuestionIndex] == quiz.results![currentQuestionIndex].correctAnswer,
      );

      selectedAnswer = null;
      if (currentQuestionIndex < quiz.results!.length - 1) {
        currentQuestionIndex++;
        startTimer(quiz);
      } else {
        isQuizCompleted = true;
        timer?.cancel();
      }
    });
  }

  void selectAnswer(String answer, QuizModel quiz) {
    setState(() {
      selectedAnswer = answer;
      userAnswers[currentQuestionIndex] = answer;
      timer?.cancel();
      moveToNextQuestion(quiz);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor,
              Color(0xFF142B1A)],
          ),
        ),
        child: Column(
          children: [
            // Custom Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: screenHeight * 0.08,
                bottom: screenHeight * 0.03,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.8),
                borderRadius:  BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset:  Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  Icon(Icons.arrow_back, color: Colors.white),
                    iconSize: screenWidth * 0.07,
                  ),
                   SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.Categoryname ?? "General Knowledge",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),

            // Main Quiz Content
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: FutureBuilder<QuizModel?>(
                  future: quizFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(child: CircularProgressIndicator(color: kAccentColor));
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Failed to load quiz data",
                              style: GoogleFonts.poppins(color: Colors.white70),
                            ),
                             SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  quizFuture = ApiService.api_quiz(widget.categoryid!);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccentColor,
                                foregroundColor: kPrimaryColor,
                              ),
                              child: Text(
                                "Retry",
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final quiz = snapshot.data!;
                      if (quiz.results == null || quiz.results!.isEmpty) {
                        return Center(
                          child: Text(
                            "No questions available for this category.",
                            style: GoogleFonts.poppins(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      if (userAnswers.isEmpty || userAnswers.length != quiz.results!.length) {
                        userAnswers = List<String?>.filled(quiz.results!.length, null);
                        answerCorrectness = List<bool>.filled(quiz.results!.length, false);
                      }

                      if (shuffledAnswers.isEmpty) {
                        shuffledAnswers = quiz.results!.map((question) {
                          final allAnswers = [...question.incorrectAnswers!, question.correctAnswer!]..shuffle();
                          return allAnswers;
                        }).toList();
                      }

                      if (isQuizCompleted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Quizresult(
                                totalQuestions: quiz.results!.length,
                                attemptedQuestions: attemptedQuestions,
                                correctAnswers: correctAnswers,
                                wrongAnswers: wrongAnswers,
                                categoryid: widget.categoryid ?? 9,
                                categoryName: widget.Categoryname ?? "General Knowledge",
                              ),
                            ),
                          );
                        });
                      }

                      if (currentQuestionIndex == 0 && secondsRemaining == 30 && timer == null) {
                        startTimer(quiz);
                      }

                      final question = quiz.results![currentQuestionIndex];
                      final unescape = HtmlUnescape();
                      final allAnswers = shuffledAnswers[currentQuestionIndex];

                      return Card(
                        elevation: 8,
                        color: kAccentColor.withOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(24.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Timer and Question Progress
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time: $secondsRemaining s",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: secondsRemaining <= 10 ? Colors.red.shade800 : kPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      "${currentQuestionIndex + 1}/${quiz.results!.length}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF142B1A),
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 20),
                                 Divider(color: kPrimaryColor),
                                 SizedBox(height: 20),

                                // Question Text
                                Text(
                                  unescape.convert(question.question!),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF142B1A),
                                  ),
                                ),
                                 SizedBox(height: 20),

                                // Answer Options
                                ...allAnswers.map((answer) {
                                  final isSelected = selectedAnswer == answer;
                                  return Padding(
                                    padding:  EdgeInsets.symmetric(vertical: 5.0),
                                    child: GestureDetector(onTap: selectedAnswer == null
                                        ? () {
                                      setState(() {
                                        selectedAnswer = answer;
                                        userAnswers[currentQuestionIndex] = answer;
                                      });
                                      // Add a slight delay to show the animation before moving to the next question
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        if (mounted) {
                                          selectAnswer(answer, quiz);
                                        }
                                      });
                                    }
                                        : null,
                                      child: AnimatedContainer(
                                        duration:  Duration(milliseconds: 200),
                                        padding:  EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: isSelected ? kPrimaryColor : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected ? kPrimaryColor :
                                            kPrimaryColor.withOpacity(0.5),
                                            width: isSelected ? 3: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset:  Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          unescape.convert(answer),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: isSelected ? Colors.white : kPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                 SizedBox(height: 20),

                                // Navigation Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        timer?.cancel();
                                        moveToNextQuestion(quiz);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Text(
                                        "Skip/Next",
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    if (currentQuestionIndex == quiz.results!.length - 1)
                                      ElevatedButton(
                                        onPressed: () {
                                          timer?.cancel();
                                          setState(() {
                                            isQuizCompleted = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        child: Text(
                                          "Finish",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}