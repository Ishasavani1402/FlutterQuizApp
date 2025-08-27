import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizapplication/ApiService/ApiService.dart';
import 'package:quizapplication/Model/QUizModel.dart';
import 'dart:async';
import 'QuizResult.dart';
import 'UserAuth/Login.dart';

class Homepage extends StatefulWidget {
  int? categoryid;
  String?Categoryname;
   Homepage({super.key ,  this.categoryid , this.Categoryname});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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

  @override
  void initState() {
    super.initState();
    quizFuture = ApiService.api_quiz(widget.categoryid!);
  }

  void startTimer(QuizModel quiz) {
    timer?.cancel();
    secondsRemaining = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void moveToNextQuestion(QuizModel quiz) {
    setState(() {
      if (userAnswers[currentQuestionIndex] != null) {
        attemptedQuestions++;
        if (userAnswers[currentQuestionIndex] == quiz.results![currentQuestionIndex].correctAnswer) {
          correctAnswers++;
          answerCorrectness[currentQuestionIndex] = true;
        } else {
          wrongAnswers++;
          answerCorrectness[currentQuestionIndex] = false;
        }
      }
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<QuizModel?>(
        future: quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load quiz data"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        quizFuture = ApiService.api_quiz(widget.categoryid!);
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else {
            final quiz = snapshot.data!;
            if (quiz.results == null || quiz.results!.isEmpty) {
              return const Center(child: Text("No questions available"));
            }

            // Initialize lists dynamically based on the number of questions
            if (userAnswers.isEmpty || userAnswers.length != quiz.results!.length) {
              userAnswers = List<String?>.filled(quiz.results!.length, null);
              answerCorrectness = List<bool>.filled(quiz.results!.length, false);
            }

            // Initialize shuffled answers for all questions once
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
              });            }

            if (currentQuestionIndex == 0 && secondsRemaining == 30 && timer == null) {
              startTimer(quiz);
            }

            final question = quiz.results![currentQuestionIndex];
            final unescape = HtmlUnescape();
            final allAnswers = shuffledAnswers[currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category : ${widget.Categoryname}"),
                  Text(
                    "Question ${currentQuestionIndex + 1}/${quiz.results!.length}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Time remaining: $secondsRemaining seconds",
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    unescape.convert(question.question!),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  ...allAnswers.map((answer) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: selectedAnswer == null
                          ? () {
                        selectAnswer(answer, quiz);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAnswer == answer ? Colors.blue : null,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(unescape.convert(answer)),
                    ),
                  )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedAnswer != null
                        ? () {
                      timer?.cancel();
                      moveToNextQuestion(quiz);
                    }
                        : null,
                    child: const Text("Next"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}