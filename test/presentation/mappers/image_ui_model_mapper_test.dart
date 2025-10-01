import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:carbon_it_images_search/presentation/mappers/image_ui_model_mapper.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('When transforming ImageEntity to ImageUiModel, should provide ImageUiModel with correct fields', () {
    // Given
    final ImageEntity imageEntity = ImageEntity(
      id: 'id',
      url: 'url',
      alt: 'alt',
      source: ImageSourceEntity(
        original: 'original',
        large: 'large',
        medium: 'medium',
        small: 'small',
        portrait: 'portrait',
        landscape: 'landscape',
        tiny: 'tiny',
      ),
    );
    final ImageUiModel expectedImageUiModelOutput = ImageUiModel(
      id: 'id',
      imageThumbnail: 'tiny',
      originalImage: 'original',
      largeImage: 'large',
      isFavorite: false,
      alt: 'alt',
    );

    // When
    final result = ImageUiModelMapper.mapImageEntityToImageUiModel(imageEntity: imageEntity);

    // Then
    expect(result, expectedImageUiModelOutput);
  });
}
