import 'package:equatable/equatable.dart';

class ImageUiModel extends Equatable {
  final String id;
  final String imageThumbnail;
  final String originalImage;
  final String largeImage;
  final bool isFavorite;
  final String? alt;

  ImageUiModel({
    required this.id,
    required this.imageThumbnail,
    required this.originalImage,
    required this.largeImage,
    required this.isFavorite,
    this.alt,
  });

  ImageUiModel copyWith({
    String? id,
    String? alt,
    String? imageThumbnail,
    String? originalImage,
    String? largeImage,
    bool? isFavorite,
  }) => ImageUiModel(
    id: id ?? this.id,
    alt: alt ?? this.alt,
    imageThumbnail: imageThumbnail ?? this.imageThumbnail,
    originalImage: originalImage ?? this.originalImage,
    largeImage: largeImage ?? this.largeImage,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  @override
  List<Object?> get props => [id, alt, imageThumbnail, originalImage, largeImage, isFavorite];
}
