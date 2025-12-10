import 'package:flutter/material.dart';
import 'package:mis_lab2/screens/meals_details_page.dart';
import '../services/meal_service.dart';
import '../models/meal.dart';

class MealsPage extends StatefulWidget {
  final String category;
  final Function(Meal) onAddToFavorites;

  const MealsPage({
    super.key,
    required this.category,
    required this.onAddToFavorites,
  });

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final api = MealApiService();
    final data = await api.fetchMealsByCategory(widget.category);
    setState(() {
      meals = data;
      filteredMeals = data;
    });
  }

  void filterLocalMeals(String query) {
    setState(() {
      filteredMeals = meals
          .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addToFavorites(Meal meal) {
    widget.onAddToFavorites(meal);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${meal.name} e додадено во омилени"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> searchMealsOnline(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredMeals = meals;
      });
      return;
    }

    final api = MealApiService();
    final results = await api.searchMeals(query);

    setState(() {
      isSearching = true;
      filteredMeals = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Пребарувај јадења",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                filterLocalMeals(query);
                searchMealsOnline(query);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailsPage(mealId: meal.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            meal.thumbnail,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            meal.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                            ),
                            onPressed: () => addToFavorites(meal),
                            child: const Text(
                              "Додади во омилени",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
