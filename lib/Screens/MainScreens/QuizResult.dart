import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for Google Fonts
import 'HomeScreen.dart';

// Use the color codes provided by the user.
const Color kPrimaryColor = Color(0xFF1C3D24);
const Color kAccentColor = Color(0xff88ab8e);
const Color kCorrectColor = Color(0xFF2E7D32); // A strong green for correct answers
const Color kWrongColor = Color(0xFFC62828);   // A strong red for wrong answers

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double score = attemptedQuestions > 0 ? (correctAnswers / attemptedQuestions) * 100 : 0;

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
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Quiz Results",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 8,
                    color: kAccentColor.withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Quiz Completed!",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Circular Score Indicator
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                child: CircularProgressIndicator(
                                  value: score / 100,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                  strokeWidth: 10,
                                ),
                              ),
                              Text(
                                "${score.toStringAsFixed(0)}%",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Results Details
                          _buildResultRow("", categoryName),
                          _buildResultRow("Total Questions:", totalQuestions.toString()),
                          _buildResultRow("Attempted:", attemptedQuestions.toString()),
                          _buildResultRow("Correct:", correctAnswers.toString(), color: kCorrectColor),
                          _buildResultRow("Wrong:", wrongAnswers.toString(), color: kWrongColor),
                          SizedBox(height: 32),

                          // Restart Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homescreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                            ),
                            child: Text(
                              "Go to Home",
                              style: GoogleFonts.poppins(
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
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a consistent result row
  Widget _buildResultRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: kPrimaryColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.visible,
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: color ?? kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,

          ),
        ],
      ),
    );
  }
}