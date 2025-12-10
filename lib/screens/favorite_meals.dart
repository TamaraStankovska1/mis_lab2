import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meals_details_page.dart';

class FavoriteMealPage extends StatelessWidget {
  final List<Meal> favoriteMeals;

  const FavoriteMealPage({super.key, required this.favoriteMeals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        title: const Text("Омилени јадења"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: favoriteMeals.isEmpty
          ? const Center(child: Text("nema omileni jadenja"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favoriteMeals[index];
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
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
