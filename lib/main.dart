import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:image_viewer_app/bottom_navigation.dart';

import 'services/services.dart';

void main()async {
   await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ImageUrlsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryImagesProvider(),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BottomNavigation(),
        ));
  }
}
