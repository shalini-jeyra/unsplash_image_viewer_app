

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/unsplash_category.dart';
import '../models/unsplash_image.dart';
import 'package:http/http.dart' as http;

class CategoryImagesProvider with ChangeNotifier {
 
   List<UnsplashCategory> _categories = [];
  List<UnsplashCategory> get categories => _categories;
  
  List<UnsplashImage> _images = [];
  List<UnsplashImage> get images => _images;
Future<void> fetchCategories() async {

  final String apiUrl = "https://api.unsplash.com/topics?client_id=${dotenv.env['UNSPLASH_API_KEY']}";

  try {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<UnsplashCategory> categories = responseData
          .map((item) => UnsplashCategory(id: item['slug'], title: item['title']))
          .toList();
       _categories = categories;
        notifyListeners();
    } else {
      print("Failed to fetch categories. Error code: ${response.statusCode}");
    
    }
  } catch (e) {
    print("Error fetching categories: $e");
    
  }
}
  Future<void> fetchImagesForCategory(String categoryId) async {

    final String apiUrl = "https://api.unsplash.com/topics/$categoryId/photos?client_id=${dotenv.env['UNSPLASH_API_KEY']}";

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<UnsplashImage> images = responseData
            .map((item) => UnsplashImage(id: item['id'], imageUrl: item['urls']['regular']))
            .toList();
        _images = images;
        notifyListeners();
      } else {
        print("Failed to fetch images. Error code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }
}
