# meetbot_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


flutter_icons:
  ios: true
  remove_alpha_ios: true
  android: true
  image_path_ios: "assets/elements/icons/icon.png"
  image_path_android: "assets/elements/icons/icon.png"

create icon:
dart run flutter_launcher_icons:main


flutter_native_splash: 
  color: "#000000"
  image: assets/elements/splash/splash.png
  color_dark: "#000000"
  image_dark: assets/elements/splash/splash.png
  ios_content_mode: scaleAspectFill
  
flutter_native_splash: 
dart run flutter_native_splash:create