import 'dart:async';

import 'package:carbon_it_images_search/data/repositories/hive_favorites_repository.dart';
import 'package:carbon_it_images_search/domain/favorites_repository_result.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hive_favorites_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Map<String, dynamic>>>()])
void main() {
  group('saveImageToFavorites', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('When saving image to favorites succeed, should return FavoritesRepositorySuccessResult', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);
      final String imageId = '9';
      final ImageUiModel imageToSave = createTestImageUiModel(id: imageId);

      // When
      final result = await repository.saveImageToFavorites(imageUiModel: imageToSave);

      // Then
      expect(box.values.length, 1);
      expect(box.values.first['id'], imageId);
      expect(result, isA<FavoritesRepositorySuccessResult>());
    });

    test('When saving image to favorites fails, should return FavoritesRepositoryErrorResult', () async {
      // Given
      final Box<Map<String, dynamic>> box = MockBox();
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);
      final String imageId = '9';
      final ImageUiModel imageToSave = createTestImageUiModel(id: imageId);
      when(
        box.put('9', {
          'id': '9',
          'width': 1024,
          'height': 1024,
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        }),
      ).thenThrow('Error');

      // When
      final FavoritesRepositoryResult result = await repository.saveImageToFavorites(imageUiModel: imageToSave);

      // Then
      expect(result, isA<FavoritesRepositoryErrorResult>());
    });
  });

  group('removeImageFromFavorites', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('When removing image from repository succeeds, should return FavoritesRepositorySuccessResult', () async {
      // Given
      final Box<Map<String, dynamic>> box = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      await box.putAll({
        '1': {
          'id': '1',
          'width': 1024,
          'height': 1024,
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        },
        '2': {
          'id': '2',
          'width': 1024,
          'height': 1024,
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        },
      });
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);

      // When
      final FavoritesRepositoryResult result = await repository.removeImageFromFavorites(imageId: '1');

      // Then
      expect(box.values.length, 1);
      expect(result, isA<FavoritesRepositorySuccessResult>());
    });

    test('When removing image from repository fails, should return FavoritesRepositoryErrorResult', () async {
      // Given
      final Box<Map<String, dynamic>> box = MockBox();
      final HiveFavoritesRepository repository = HiveFavoritesRepository(favoritesBox: box);
      when(box.delete('1')).thenThrow('Error');

      // When
      final FavoritesRepositoryResult result = await repository.removeImageFromFavorites(imageId: '1');

      // Then
      expect(result, isA<FavoritesRepositoryErrorResult>());
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
          'width': 1024,
          'height': 1024,
          'alt': 'alt',
          'imageThumbnail': 'imageThumbnail',
          'originalImage': 'originalImage',
          'largeImage': 'largeImage',
          'isFavorite': false,
        },
        '2': {
          'id': '2',
          'width': 1024,
          'height': 1024,
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

  group('watchFavoritesIds', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('When subscribing to favoritesIds, should emit already saved ids', () async {
      // Given
      final Box<Map<String, dynamic>> favoritesBox = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      await favoritesBox.put('1', <String, dynamic>{});
      await favoritesBox.put('2', <String, dynamic>{});
      final HiveFavoritesRepository favoritesRepository = HiveFavoritesRepository(favoritesBox: favoritesBox);

      // When
      final Set<String> firstEmission = await favoritesRepository.watchFavoritesIds().first;

      // Then
      expect(firstEmission, {'1', '2'});
    });

    test('When hive box is modified, watchFavoritesIds should emit each modification', () async {
      // Given
      final Box<Map<String, dynamic>> favoritesBox = await Hive.openBox<Map<String, dynamic>>('favorites_v1');
      await favoritesBox.clear();
      final HiveFavoritesRepository favoritesRepository = HiveFavoritesRepository(favoritesBox: favoritesBox);
      final StreamIterator<Set<String>> streamIterator = StreamIterator<Set<String>>(
        favoritesRepository.watchFavoritesIds(),
      );

      // When / Then
      expect(await streamIterator.moveNext(), true);
      expect(streamIterator.current, <String>{});

      await favoritesBox.put('1', <String, dynamic>{});
      expect(await streamIterator.moveNext(), true);
      expect(streamIterator.current, <String>{'1'});

      await favoritesBox.put('2', <String, dynamic>{});
      expect(await streamIterator.moveNext(), true);
      expect(streamIterator.current, <String>{'1', '2'});

      await favoritesBox.delete('1');
      expect(await streamIterator.moveNext(), true);
      expect(streamIterator.current, <String>{'2'});

      await streamIterator.cancel();
    });
  });
}

ImageUiModel createTestImageUiModel({required String id}) => ImageUiModel(
  id: id,
  width: 1024,
  height: 1024,
  alt: 'alt',
  imageThumbnail: 'imageThumbnail',
  originalImage: 'originalImage',
  largeImage: 'largeImage',
  isFavorite: false,
);
