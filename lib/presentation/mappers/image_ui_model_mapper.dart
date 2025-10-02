import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

class ImageUiModelMapper {
  static ImageUiModel mapImageEntityToImageUiModel({required ImageEntity imageEntity}) => ImageUiModel(
    id: imageEntity.id,
    width: imageEntity.width,
    height: imageEntity.height,
    alt: imageEntity.alt,
    imageThumbnail: imageEntity.source.tiny,
    originalImage: imageEntity.source.original,
    largeImage: imageEntity.source.large,
    isFavorite: false,
  );
}
