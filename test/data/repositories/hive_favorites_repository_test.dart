import 'package:carbon_it_images_search/data/repositories/hive_favorites_repository.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      final ImageUiModel imageToSave = createTestImageUiModel(id: imageId);

      // When
      repository.saveImageToFavorites(imageUiModel: imageToSave);

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
          'id': '1',
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        },
        '2': {
          'id': '2',
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
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
      final ImageUiModel imageEntity1 = createTestImageUiModel(id: '1');
      final ImageUiModel imageEntity2 = createTestImageUiModel(id: '2');

      await box.putAll({
        '1': {
          'id': '1',
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        },
        '2': {
          'id': '2',
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
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

ImageUiModel createTestImageUiModel({required String id}) => ImageUiModel(
  id: id,
  alt: 'alt',
  imageThumbnail: 'imageThumbnail',
  originalImage: 'originalImage',
  largeImage: 'largeImage',
  isFavorite: false,
);
