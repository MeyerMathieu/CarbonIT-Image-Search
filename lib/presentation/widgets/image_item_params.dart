import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:flutter/cupertino.dart';

class ImageItemParams {
  final BoxFit boxFit;
  final bool isFavorite;
  final double aspectRatio;
  final String imageSource;
  final String? alt;

  const ImageItemParams({
    required this.boxFit,
    required this.isFavorite,
    required this.aspectRatio,
    required this.imageSource,
    required this.alt,
  });

  factory ImageItemParams.forSearchResults({required ImageUiModel imageUiModel}) => ImageItemParams(
    boxFit: BoxFit.cover,
    isFavorite: imageUiModel.isFavorite,
    aspectRatio: 1,
    imageSource: imageUiModel.imageThumbnail,
    alt: imageUiModel.alt,
  );

  factory ImageItemParams.forFavoritesList({required ImageUiModel imageUiModel}) => ImageItemParams(
    boxFit: BoxFit.contain,
    isFavorite: imageUiModel.isFavorite,
    aspectRatio: imageUiModel.width / imageUiModel.height,
    imageSource: imageUiModel.largeImage,
    alt: imageUiModel.alt,
  );
}
