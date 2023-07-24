import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

class ViewCategoryPage extends StatelessWidget {
  final String categoryId;


  ViewCategoryPage({required this.categoryId, });

  @override
  Widget build(BuildContext context) {
    final categoryImagesProvider = Provider.of<CategoryImagesProvider>(context, listen: false);

    return Scaffold(
    appBar: AppBar(
        title: Text('Category Images'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: categoryImagesProvider.fetchImagesForCategory(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching images"));
            } else {
              return Consumer<CategoryImagesProvider>(
                builder: (context, provider, _) {
                  return  GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: categoryImagesProvider.images.length,
            itemBuilder: (context, index) {
              final image = categoryImagesProvider.images[index];
              return Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
              );
            },
          );
                }
              );
            }
          },
        ),
      ),
    );
  }
}
