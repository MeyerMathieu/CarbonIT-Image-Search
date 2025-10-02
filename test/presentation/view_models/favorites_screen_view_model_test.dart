import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/favorites_states.dart';
import 'package:carbon_it_images_search/presentation/view_models/favorites_screen_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'search_screen_view_model_test.mocks.dart';

void main() {
  group('loadFavorites', () {
    test('When repository is called, should set state to FavoritesStateLoading', () {
      // Given
      final FavoritesRepository favoritesRepository = MockFavoritesRepository();
      final FavoritesScreenViewModel favoritesScreenViewModel = FavoritesScreenViewModel(
        favoritesRepository: favoritesRepository,
      );

      // When
      favoritesScreenViewModel.loadFavorites();

      // Then
      expect(favoritesScreenViewModel.state, isA<FavoritesStateLoading>());
    });

    test('When repository returns an empty list, should set state to FavoritesStateEmpty', () async {
      // Given
      final FavoritesRepository favoritesRepository = MockFavoritesRepository();
      final FavoritesScreenViewModel favoritesScreenViewModel = FavoritesScreenViewModel(
        favoritesRepository: favoritesRepository,
      );
      when(favoritesRepository.getFavorites()).thenAnswer((_) async => <ImageUiModel>[]);

      // When
      await favoritesScreenViewModel.loadFavorites();

      // Then
      expect(favoritesScreenViewModel.state, isA<FavoritesStateEmpty>());
    });

    test(
      'When repository returns a list of 2 items, should set state to FavoritesStateSuccess with correct items',
      () async {
        // Given
        final FavoritesRepository favoritesRepository = MockFavoritesRepository();
        final FavoritesScreenViewModel favoritesScreenViewModel = FavoritesScreenViewModel(
          favoritesRepository: favoritesRepository,
        );
        final List<ImageUiModel> expectedImageUiModelListOutput = [
          ImageUiModel(
            id: 'id1',
            width: 1024,
            height: 1024,
            imageThumbnail: 'imageThumbnail',
            originalImage: 'originalImage',
            largeImage: 'largeImage',
            isFavorite: true,
          ),
          ImageUiModel(
            id: 'id2',
            width: 1024,
            height: 1024,
            imageThumbnail: 'imageThumbnail',
            originalImage: 'originalImage',
            largeImage: 'largeImage',
            isFavorite: true,
          ),
        ];
        when(favoritesRepository.getFavorites()).thenAnswer((_) async => expectedImageUiModelListOutput);

        // When
        await favoritesScreenViewModel.loadFavorites();

        // Then
        expect(favoritesScreenViewModel.state, isA<FavoritesStateSuccess>());
        expect((favoritesScreenViewModel.state as FavoritesStateSuccess).imagesItems, expectedImageUiModelListOutput);
      },
    );

    test('When repository returns an error, should set state to FavoritesStateError with error message', () async {
      // Given
      final FavoritesRepository favoritesRepository = MockFavoritesRepository();
      final FavoritesScreenViewModel favoritesScreenViewModel = FavoritesScreenViewModel(
        favoritesRepository: favoritesRepository,
      );
      when(favoritesRepository.getFavorites()).thenThrow('Error');

      // When
      await favoritesScreenViewModel.loadFavorites();

      // Then
      expect(favoritesScreenViewModel.state, isA<FavoritesStateError>());
      expect((favoritesScreenViewModel.state as FavoritesStateError).errorMessage, 'Error');
    });
  });

  group('removeImageFromFavorites', () {
    // TODO
  }, skip: true);
}
