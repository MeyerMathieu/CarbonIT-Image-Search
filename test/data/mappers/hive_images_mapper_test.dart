import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:carbon_it_images_search/data/mappers/hive_images_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('serializeToMap', () {
    test('When serializing an ImageEntity, should return a map with correct values', () {
      // Given
      final ImageEntity imageToSerialize = ImageEntity(
        id: 'id',
        url: 'url',
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
      final Map<String, dynamic> expectedOutput = {
        'id': 'id',
        'url': 'url',
        'src': {
          'original': 'original',
          'large': 'large',
          'medium': 'medium',
          'small': 'small',
          'portrait': 'portrait',
          'landscape': 'landscape',
          'tiny': 'tiny',
        },
      };

      // When
      final Map<String, dynamic> result = HiveImagesMapper.serializeToMap(imageEntity: imageToSerialize);

      // Then
      expect(result, expectedOutput);
    });
  });

  group('deserializeFromMap', () {
    test('When deserializing a map, should return an ImageEntity with correct values', () {
      // Given
      final Map<String, dynamic> mapToDeserialize = {
        'id': 'id',
        'url': 'url',
        'src': {
          'original': 'original',
          'large': 'large',
          'medium': 'medium',
          'small': 'small',
          'portrait': 'portrait',
          'landscape': 'landscape',
          'tiny': 'tiny',
        },
      };
      final ImageEntity expectedImageEntityOutput = ImageEntity(
        id: 'id',
        url: 'url',
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

      // When
      final ImageEntity result = HiveImagesMapper.deserializeFromMap(map: mapToDeserialize);

      // Then
      expect(result, expectedImageEntityOutput);
    });
  });
}
