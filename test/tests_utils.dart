import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

ImageUiModel buildTestImageUiModel({required String id, bool isFavorite = false}) => ImageUiModel(
  id: id,
  width: 1024,
  height: 1024,
  alt: 'alt',
  imageThumbnail: 'tiny',
  originalImage: 'original',
  largeImage: 'large',
  isFavorite: isFavorite,
);
