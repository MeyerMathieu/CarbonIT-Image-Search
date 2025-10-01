import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:carbon_it_images_search/data/repositories/hive_favorites_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  group('saveImageToFavorites', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);
      final String imageId = '9';
      final ImageEntity imageToSave = createTestImageEntity(id: imageId);

      // When
      repository.saveImageToFavorites(imageEntity: imageToSave);

      // Then
      expect(box.values.length, 1);
      expect(box.values.first['id'], imageId);
    });
  });

  group('removeImageFromFavorites', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('When removing image from repository, should delete key/value pair from Hive box', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      await box.putAll({
        '1': {
          'id': 1,
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
        },
        '2': {
          'id': 2,
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
        },
      });
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);

      // When
      repository.removeImageFromFavorites(imageId: 1);

      // Then
      expect(box.values.length, 1);
    });
  });

  group('getFavorites', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('When Hive box is empty, should return empty list', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);

      // When
      final result = await repository.getFavorites();

      // Then
      expect(result, []);
    });

    test('When Hive box contains 2 items, should return list of 2 ImageEntity', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      final ImageEntity imageEntity1 = createTestImageEntity(id: '1');
      final ImageEntity imageEntity2 = createTestImageEntity(id: '2');

      await box.putAll({
        '1': {
          'id': 1,
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
        },
        '2': {
          'id': 2,
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
        },
      });
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);

      // When
      final result = await repository.getFavorites();

      // Then
      expect(result, [imageEntity1, imageEntity2]);
    });
  });
}

ImageEntity createTestImageEntity({required String id}) {
  return ImageEntity(
    id: id,
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
}
