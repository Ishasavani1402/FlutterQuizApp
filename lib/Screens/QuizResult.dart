import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class Quizresult extends StatelessWidget {
  final int totalQuestions;
  final int attemptedQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int categoryid;
  final String categoryName;

  const Quizresult({
    super.key,
    required this.totalQuestions,
    required this.attemptedQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.categoryid,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Results"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Quiz Completed!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Category: $categoryName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Total Questions: $totalQuestions", style: const TextStyle(fontSize: 16)),
            Text("Attempted: $attemptedQuestions", style: const TextStyle(fontSize: 16)),
            Text("Correct: $correctAnswers", style: const TextStyle(fontSize: 16, color: Colors.green)),
            Text("Wrong: $wrongAnswers", style: const TextStyle(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(
                      categoryid: categoryid,
                      Categoryname: categoryName,
                    ),
                  ),
                );
              },
              child: const Text("Restart Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}