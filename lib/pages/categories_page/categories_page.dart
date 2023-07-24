import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_viewer_app/pages/pages.dart';


import 'package:provider/provider.dart';

import '../../services/services.dart';

Color getRandomColor() {
  final Random random = Random();
  final int r = 150 + random.nextInt(106);
  final int g = 150 + random.nextInt(106); 
  final int b = 150 + random.nextInt(106); 
  return Color.fromARGB(255, r, g, b);
}

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryImagesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: categoriesProvider.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: categoriesProvider.categories.length,
                itemBuilder: (context, index) {
                   final color = getRandomColor();
                  return GestureDetector(
                    onTap: () {
                    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewCategoryPage(
                            categoryId: categoriesProvider.categories[index].id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                        color: color,
                      child: Center(
                        child: Text(categoriesProvider.categories[index].title,style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),textAlign: TextAlign.center,),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
