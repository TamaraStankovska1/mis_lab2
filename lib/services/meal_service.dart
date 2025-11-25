import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_details.dart';

class MealApiService {
  static const String categoriesUrl =
      "https://www.themealdb.com/api/json/v1/1/categories.php";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(categoriesUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((json) => Category.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load categories");
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$category";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List)
          .map((json) => Meal.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load meals");
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) return [];

      return (data['meals'] as List)
          .map((json) => Meal.fromJson(json))
          .toList();
    }
    throw Exception("Failed to search meals");
  }
  Future<MealDetail> fetchMealDetails(String id) async {
    final url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception("Failed to load meal details");
    }
  }
}
