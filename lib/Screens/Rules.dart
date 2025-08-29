import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Use the color codes provided by the user.
const Color kPrimaryColor = Color(0xFF1C3D24);
const Color kAccentColor = Color(0xff88ab8e);

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {

  // A helper method to build each individual rule item for reusability and clean code
  Widget _buildRuleItem({required IconData icon, required String title, required String description}) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon for the rule with a dark green color
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kAccentColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: kPrimaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Expanded to ensure text wraps correctly
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title of the rule
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Description of the rule
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a gradient for a unique and dynamic background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kAccentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Quiz Rules',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content area with a polished design
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      // Rule 1: Authentication
                      _buildRuleItem(
                        icon: Icons.person_outline,
                        title: 'Log In to Participate',
                        description: 'You must first register with an email and password or log in with your Google account to start the quiz.',
                      ),

                      // Rule 2: Category Selection
                      _buildRuleItem(
                        icon: Icons.view_list_outlined,
                        title: 'Select Your Category',
                        description: 'After logging in, you will choose a quiz '
                            'category. Questions will be loaded based on your selection.',
                      ),

                      // Rule 3: Playing the Quiz
                      _buildRuleItem(
                        icon: Icons.play_arrow_outlined,
                        title: 'Start Playing',
                        description: 'Answer questions one by one. Each Question have 30 Seconds'
                            'Give your Input Carefully!!!s',
                      ),

                      // Rule 4: Viewing Results
                      _buildRuleItem(
                        icon: Icons.emoji_events_outlined,
                        title: 'See Your Results',
                        description: 'Once all questions are answered, your final results will be displayed, showing your correct and incorrect answers.',
                      ),
                      const SizedBox(height: 16),

                      // Action button to acknowledge the rules
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement navigation to the next screen (e.g., category selection)
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryScreen()));
                          print('User has accepted the rules!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          'I Understand',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}