import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

class HiveImagesMapper {
  static Map<String, dynamic> serializeToMap({required ImageUiModel imageUiModel}) => <String, dynamic>{
    'id': imageUiModel.id,
    'imageThumbnail': imageUiModel.imageThumbnail,
    'originalImage': imageUiModel.originalImage,
    'largeImage': imageUiModel.largeImage,
    'isFavorite': imageUiModel.isFavorite,
    'alt': imageUiModel.alt,
    'width': imageUiModel.width,
    'height': imageUiModel.height,
  };

  static ImageUiModel deserializeFromMap({required Map<String, dynamic> map}) => ImageUiModel(
    id: map['id'].toString(),
    imageThumbnail: map['imageThumbnail'],
    originalImage: map['originalImage'],
    largeImage: map['largeImage'],
    isFavorite: map['isFavorite'],
    alt: map['alt'],
    width: map['width'],
    height: map['height'],
  );
}
