# ImageViewerApp

ImageViewerApp is a Flutter app that allows users to view and interact with images. The app consists of two bottom navigation tabs: Home and Categories.

## Home Page
The Home page displays a search bar and a list of images. Users can enter a search query in the search bar to filter the images. The images can be cropped, downloaded, and viewed in the gallery. The image list supports infinite scrolling, and more images will be loaded as the user scrolls down.

### Features:
- Search Images: Users can enter a search query in the search bar to find images.
- Infinite Scrolling: Additional images are automatically loaded as the user scrolls down.
- Image Cropping: Users can crop the selected image using the crop tool.
- Image Download: Users can download the selected image to their device.
- View in Gallery: Users can view the downloaded or cropped image in their device's gallery.

## Categories Page
The Categories page displays a list of categories. Users can select a category to view a list of images related to that category. The category list also supports infinite scrolling, and more categories will be loaded as the user scrolls down.

### Features:
- View Categories: Users can browse a list of categories.
- View Category Images: Users can select a category to view a list of images related to that category.
- Infinite Scrolling: Additional categories are automatically loaded as the user scrolls down.

## Dependencies
- [flutter_image_cropper](https://pub.dev/packages/flutter_image_cropper): Used for image cropping functionality.
- [http](https://pub.dev/packages/http): Used to make HTTP requests for fetching image data.
- [permission_handler](https://pub.dev/packages/permission_handler): Used to request storage permissions for image downloads.
- [cached_network_image](https://pub.dev/packages/cached_network_image): Used to display cached images from the network.
- [image_gallery_saver](https://pub.dev/packages/image_gallery_saver): Used to save images to the device's gallery.
- [provider](https://pub.dev/packages/provider): Used for state management.

## How to Use
1. Clone this repository to your local machine.
2. Open the project in Flutter IDE (e.g., Android Studio, VSCode).
3. Run `flutter pub get` to fetch the required dependencies.
4. Obtain an Unsplash API key from the [Unsplash developer portal](https://unsplash.com/developers).
5. Create a `.env` file in the root directory of the project and add your Unsplash API key:

UNSPLASH_API_KEY=your_unsplash_api_key

6. Save the `.env` file and run the app on your emulator or physical device.

## Notes
- This app uses the Unsplash API to fetch images and categories. Please make sure to follow Unsplash's terms of use and attribution requirements.
- The image cropping functionality may vary on different devices and may not be supported on some devices.

## Screenrecords
![All pages](screen_record/video.mp4)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.