import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ApiService/ApiService.dart';
import '../Model/Category.dart';
import 'StartQuiz.dart';

// Use the color codes provided by the user.
 Color kPrimaryColor = Color(0xFF1C3D24);
 Color kAccentColor = Color(0xff88ab8e);

class CategoryScreen extends StatelessWidget {
   CategoryScreen({super.key});

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
            colors: [kPrimaryColor, Color(0xFF142B1A)],
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
                      "Select a Category",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area with Categories in a Grid
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: FutureBuilder<CategoryModel?>(
                  future: ApiService.getCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(child: CircularProgressIndicator(color: kAccentColor));
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Center(
                        child: Text(
                          "Failed to load categories. Please try again.",
                          style: GoogleFonts.poppins(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      final categoryModel = snapshot.data!;
                      final categories = categoryModel.triviaCategories ?? [];
                      if (categories.isEmpty) {
                        return Center(
                          child: Text(
                            "No categories available",
                            style: GoogleFonts.poppins(color: Colors.white70),
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio:0.8, // To make the cards square
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Startquiz(
                                    categoryid: cat.id,
                                    Categoryname: cat.name,
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration:  Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: kAccentColor.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset:  Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:  EdgeInsets.all(13),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      color: kPrimaryColor,
                                      size: screenWidth * 0.12,
                                    ),
                                     SizedBox(height: screenHeight * 0.03),
                                    Text(
                                      cat.name ?? "Unknown Category",
                                      textAlign: TextAlign.center,
                                      textWidthBasis: TextWidthBasis.longestLine,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF142B1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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