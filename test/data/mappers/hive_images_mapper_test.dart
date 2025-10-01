import 'package:carbon_it_images_search/data/mappers/hive_images_mapper.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('serializeToMap', () {
    test('When serializing an ImageEntity, should return a map with correct values', () {
      // Given
      final ImageUiModel imageToSerialize = ImageUiModel(
        id: 'id',
        alt: 'alt',
        imageThumbnail: 'imageThumbnail',
        originalImage: 'originalImage',
        largeImage: 'largeImage',
        isFavorite: false,
      );
      final Map<String, dynamic> expectedOutput = {
        'id': 'id',
        'alt': 'alt',
        'imageThumbnail': 'imageThumbnail',
        'originalImage': 'originalImage',
        'largeImage': 'largeImage',
        'isFavorite': false,
      };

      // When
      final Map<String, dynamic> result = HiveImagesMapper.serializeToMap(imageUiModel: imageToSerialize);

      // Then
      expect(result, expectedOutput);
    });
  });

  group('deserializeFromMap', () {
    test('When deserializing a map, should return an ImageEntity with correct values', () {
      // Given
      final Map<String, dynamic> mapToDeserialize = {
        'id': 'id',
        'alt': 'alt',
        'imageThumbnail': 'imageThumbnail',
        'originalImage': 'originalImage',
        'largeImage': 'largeImage',
        'isFavorite': false,
      };
      final ImageUiModel expectedImageEntityOutput = ImageUiModel(
        id: 'id',
        alt: 'alt',
        imageThumbnail: 'imageThumbnail',
        originalImage: 'originalImage',
        largeImage: 'largeImage',
        isFavorite: false,
      );

      // When
      final ImageUiModel result = HiveImagesMapper.deserializeFromMap(map: mapToDeserialize);

      // Then
      expect(result, expectedImageEntityOutput);
    });
  });
}
