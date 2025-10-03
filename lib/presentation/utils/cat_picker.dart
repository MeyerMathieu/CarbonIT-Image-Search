import 'dart:math';

class CatPicker {
  static List<String> assets = [
    'assets/images/cats/cat-1.png',
    'assets/images/cats/cat-2.png',
    'assets/images/cats/cat-3.png',
  ];

  static String pickImageAsset() => assets[Random().nextInt(assets.length)];
}
