import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class ImageUrlsProvider with ChangeNotifier {

  List<String> _imageUrls = [];

  List<String> get imageUrls => _imageUrls;
 int _currentPage = 1;
  String currentQuery = '';
  bool _isLoading = false;


  Future<void> fetchImages(String query, {bool loadMore = false}) async {
    if (!loadMore) {
      _currentPage = 1;
      _imageUrls.clear();
      currentQuery = query;
    }

    if (_isLoading) {
      return; 
    }

    _isLoading = true; 

    final String apiUrl = "https://api.unsplash.com/search/photos/?client_id=${dotenv.env['UNSPLASH_API_KEY']}&query=$currentQuery&page=$_currentPage";

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> imageList = responseData['results'];

        List<String> newImageUrls =
            imageList.map((item) => item['urls']['regular'] as String).toList();

        _imageUrls.addAll(newImageUrls);

        notifyListeners();
      } else {
        print("Failed to fetch images. Error code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    } finally {
      _isLoading = false; 
    }
  }

  void loadMoreImages() {
    _currentPage++;
    fetchImages(currentQuery, loadMore: true);
  }
void loadMoreInitialImages() {
  _currentPage++;
  fetchInitialImages(loadMore: true);
}

Future<void> fetchInitialImages({bool loadMore = false}) async {
  try {
    final String apiUrl = "https://api.unsplash.com/photos?page=$_currentPage&client_id=${dotenv.env['UNSPLASH_API_KEY']}";

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<String> newImageUrls =
          responseData.map((item) => item['urls']['regular'] as String).toList();

      if (loadMore) {
       
        _imageUrls.addAll(newImageUrls);
      } else {
        
        _imageUrls = newImageUrls;
      }

      notifyListeners();
    } else {
      print("Failed to fetch images. Error code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching images: $e");
  }
}



}