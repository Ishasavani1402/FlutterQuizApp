import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizapplication/Model/Category.dart';
import 'package:quizapplication/Model/QUizModel.dart';

class ApiService {
  static Future<CategoryModel?> getCategory() async {
    try {
      var url = "https://opentdb.com/api_category.php";
      var uri = Uri.parse(url);
      var response = await http.get(uri);
      print("Category Response : ${response.statusCode} : ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsondata = jsonDecode(response.body);
        return CategoryModel.fromJson(jsondata);
      }
    } catch (e) {
      print("Failed to fetch category data : ${e.toString()}");
      return null;
    }
  }

  static Future<QuizModel?> api_quiz(int categoryid) async {
    try {
      var url =
          "https://opentdb.com/api.php?amount=10&category=$categoryid&difficulty=easy&type=multiple";
      var uri = Uri.parse(url);
      var response = await http.get(uri);
      print("Api Response for category :$categoryid : ${response.statusCode} : ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsondata = jsonDecode(response.body);
        return QuizModel.fromJson(jsondata);
      }
    } catch (e) {
      print("Failed to fetch quiz data : ${e.toString()}");
      return null;
    }
  }

}
