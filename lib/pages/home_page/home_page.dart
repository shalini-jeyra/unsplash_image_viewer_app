import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_viewer_app/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
static const Duration _debounceDuration = Duration(milliseconds: 500);
  Timer? _debounceTimer;

  void _onSearchSubmitted(String query, ImageUrlsProvider imageUrlsProvider) {
    if (query.isEmpty) {
    
    imageUrlsProvider.fetchInitialImages();
  } else {
    
    imageUrlsProvider.fetchImages(query);
  }
  }
  void _onSearchChanged(String query, ImageUrlsProvider imageUrlsProvider) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _onSearchSubmitted(query, imageUrlsProvider);
    });
  }
  void _onImageSelected(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailsPage(imageUrl: imageUrl),
      ),
    );
  }
  
@override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    Provider.of<ImageUrlsProvider>(context, listen: false).fetchInitialImages();
   _scrollController.addListener(_onScroll);
  }
  void _onScroll() {
      final imageUrlsProvider = Provider.of<ImageUrlsProvider>(context, listen: false);
    if (_scrollController.position.extentAfter == 0) {

      if (imageUrlsProvider.currentQuery.isEmpty) {
        imageUrlsProvider.loadMoreInitialImages();
      } else {
        imageUrlsProvider.loadMoreImages();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final imageUrlsProvider = Provider.of<ImageUrlsProvider>(context);

    return Scaffold(
     
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
        onChanged: (query) => _onSearchChanged(query, imageUrlsProvider),
        decoration: InputDecoration(
          labelText: "Search Images",
          hintText: "Enter your search query",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
      
            ),
            Expanded(
              child: imageUrlsProvider.imageUrls.isEmpty
                  ? Center(
                      child: Text("No images found. Try searching for something."),
                    )
                  : NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                
                   if (scrollNotification is ScrollEndNotification &&
                            _scrollController.position.extentAfter == 0) {
                          if (imageUrlsProvider.currentQuery.isEmpty) {
                            imageUrlsProvider.loadMoreInitialImages();
                          } else {
                            imageUrlsProvider.loadMoreImages();
                          }
                        }
                        return true;
                      },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5,
                  childAspectRatio: 0.8),
                  itemCount: imageUrlsProvider.imageUrls.length,
                  itemBuilder: (context, index) {
                   
                    
                 double imageHeight = index % 2 == 0 ? 50.0 : 250.0;
                    double imageWidth = index % 2 == 0 ? 10.0 : 200.0;
                    return GestureDetector(
                      onTap: () => _onImageSelected(context, imageUrlsProvider.imageUrls[index]),
                      child: CachedNetworkImage(
                        imageUrl: imageUrlsProvider.imageUrls[index],
                             height: imageHeight,
                             
                        width: imageWidth,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ),
                ),
      
              ),
            ),
          ],
        ),
      ),
    );
  }
}
