

import 'dart:async';
import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart'as http;
class ImageDetailsPage extends StatefulWidget {
  final String imageUrl;

 ImageDetailsPage({required this.imageUrl});

  @override
  State<ImageDetailsPage> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
 String? _croppedImageUrl;

Future<void> _downloadImage(BuildContext context, String imageUrl) async {
  final String downloadUrl = _croppedImageUrl ?? imageUrl; // Use _croppedImageUrl if available, otherwise use the original imageUrl

  if (_croppedImageUrl != null) {
    // If _croppedImageUrl is a local file path, directly save it to the gallery
    try {
      final File croppedImageFile = File(_croppedImageUrl!);
      final result = await ImageGallerySaver.saveFile(croppedImageFile.path);
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
            children: [
              Flexible(child: Text("Image downloaded and saved to gallery successfully!")),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed:()=> _viewImageInGallery(croppedImageFile.path),
                child: Text("View in Gallery"),
              ),
            ],
          ),
          ),
        );
      } else {
        print("Failed to save image to gallery: ${result['errorMessage']}");
      }
    } catch (e) {
      print("Error saving image to gallery: $e");
    }
  } else {
    
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final http.Response response = await http.get(Uri.parse(downloadUrl));
    
        final Directory? appDocDir = await getExternalStorageDirectory();
        final String appDocPath = appDocDir!.path;

       
        final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
        final File imageFile = File('$appDocPath/$fileName');

        await imageFile.writeAsBytes(response.bodyBytes);

        final result = await ImageGallerySaver.saveFile(imageFile.path);
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
          content:   Row(
            children: [
              Flexible(child: Text("Image downloaded and saved to gallery successfully!")),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed:()=> _viewImageInGallery(imageFile.path),
                child: Text("View in Gallery"),
              ),
            ],
          ),
            ),
          );
        } else {
          print("Failed to save image to gallery: ${result['errorMessage']}");
        }
      } catch (e) {
        print("Error downloading image: $e");
      }
    } else {
      print("Permission denied");
    }
  }
}  Future<void> _viewImageInGallery(String image) async {
    final savedImagePath = image;
    await OpenFile.open(savedImagePath);
  }


Future<void> _cropImage() async {
  try {
   
    http.Response response = await http.get(Uri.parse(widget.imageUrl));
    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String tempFileName = 'temp_image.jpg';
      String tempFilePath = '$tempPath/$tempFileName';
      File tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(response.bodyBytes);

     
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: tempFilePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
        ],
        uiSettings: [
         AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
         IOSUiSettings(
          title: 'Crop Image',
          minimumAspectRatio: 1.0,
        ),
        ]
      );

       if (croppedImage != null) {
      

        setState(() {
           _croppedImageUrl = croppedImage.path;
            print("Cropped Image Path: $_croppedImageUrl");
        });
  
      } else {
            print("User canceled the cropping action.");
      }

      await tempFile.delete();
    } else {
      print('Failed to download image. Error code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error cropping image: $e');
  }
}

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
     
     
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: _croppedImageUrl != null
                    ? File(_croppedImageUrl!).existsSync()
                        ? Image.file(File(_croppedImageUrl!))
                        : Text("Cropped image not found!") 
                    : CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               IconButton(
                icon: Icon(Icons.crop),
                onPressed: _cropImage,
              ),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed:()=> _downloadImage(context,widget.imageUrl),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}