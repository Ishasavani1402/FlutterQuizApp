import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ApiService/ApiService.dart';
import '../Model/Category.dart';
import 'HomePage.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Category")),
      body: FutureBuilder<CategoryModel?>(
        future: ApiService.getCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Failed to load categories"));
          } else {
            final categoryModel = snapshot.data!;
            final categories = categoryModel.triviaCategories ?? [];
            if (categories.isEmpty) {
              return const Center(child: Text("No categories available"));
            }
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  title: Text(cat.name ?? "Unknown Category"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Homepage(categoryid: cat.id , Categoryname: cat.name),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}