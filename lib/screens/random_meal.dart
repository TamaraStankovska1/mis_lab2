import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/meals_details_page.dart';

class RandomMealPage extends StatefulWidget {
  const RandomMealPage({super.key});

  @override
  State<RandomMealPage> createState() => _RandomMealPageState();
}

class _RandomMealPageState extends State<RandomMealPage> {
  Map<String, dynamic>? meal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomMeal();
  }

  Future<void> fetchRandomMeal() async {
    const url = "https://www.themealdb.com/api/json/v1/1/random.php";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meal = data["meals"][0];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Рандом рецепт за денот"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : MealDetailsPage(mealId: meal!["idMeal"]),
    );
  }
}
