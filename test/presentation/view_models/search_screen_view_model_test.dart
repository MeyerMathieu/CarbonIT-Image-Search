import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:carbon_it_images_search/domain/favorites_repository_result.dart';
import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/search_states.dart';
import 'package:carbon_it_images_search/presentation/view_models/search_screen_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_screen_view_model_test.mocks.dart';

// TODO : Move mocks in another file
@GenerateNiceMocks([MockSpec<ImagesSearchRepository>(), MockSpec<FavoritesRepository>()])
void main() {
  group('submitSearch', () {
    final ImagesSearchRepository imagesSearchRepository = MockImagesSearchRepository();
    final FavoritesRepository favoritesRepository = MockFavoritesRepository();
    final SearchScreenViewModel viewModel = SearchScreenViewModel(
      imagesSearchRepository: imagesSearchRepository,
      favoritesRepository: favoritesRepository,
    );
    final String searchValue = 'searchValue';

    test('When a search is submitted and repository returns a list of items, should set state items', () async {
      // Given
      final ImageSourceEntity imageSourceEntity = ImageSourceEntity(
        original: 'original',
        large: 'large',
        medium: 'medium',
        small: 'small',
        portrait: 'portrait',
        landscape: 'landscape',
        tiny: 'tiny',
      );
      final List<ImageEntity> repositorySuccessResult = [
        ImageEntity(id: 'id1', width: 1024, height: 1024, source: imageSourceEntity),
        ImageEntity(id: 'id2', width: 1024, height: 1024, source: imageSourceEntity),
      ];
      final List<ImageUiModel> resultImagesItems = [
        ImageUiModel(
          id: repositorySuccessResult.first.id,
          width: repositorySuccessResult.first.width,
          height: repositorySuccessResult.first.height,
          imageThumbnail: imageSourceEntity.tiny,
          originalImage: imageSourceEntity.original,
          largeImage: imageSourceEntity.large,
          isFavorite: false,
        ),
        ImageUiModel(
          id: repositorySuccessResult.last.id,
          width: repositorySuccessResult.first.width,
          height: repositorySuccessResult.first.height,
          imageThumbnail: imageSourceEntity.tiny,
          originalImage: imageSourceEntity.original,
          largeImage: imageSourceEntity.large,
          isFavorite: false,
        ),
      ];
      when(imagesSearchRepository.searchImages(search: searchValue)).thenAnswer((_) async => repositorySuccessResult);

      // When
      await viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, null);
      expect(viewModel.state.imagesItems.length, 2);
      expect(viewModel.state.imagesItems, resultImagesItems);
    });

    test('When a search is submitted, should set state to loading', () {
      // When
      viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state.isLoading, true);
      expect(viewModel.state.lastQuery, searchValue);
      expect(viewModel.state.errorMessage, null);
      expect(viewModel.state.imagesItems.length, 0);
    });

    test('When the repository throws an error, should set state to error', () {
      // Given
      final String repositoryErrorMessage = 'Error';
      when(imagesSearchRepository.searchImages(search: searchValue)).thenThrow(repositoryErrorMessage);

      // When
      viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.lastQuery, searchValue);
      expect(viewModel.state.errorMessage, repositoryErrorMessage);
      expect(viewModel.state.imagesItems.length, 0);
    });
  });

  group('toggleItemFavorite', () {
    setUpAll(() {
      provideDummy<FavoritesRepositoryResult>(const FavoritesRepositoryErrorResult(false));
    });

    test('When the item is not in favorites, should add it to repository', () async {
      // Given
      final favoritesRepository = MockFavoritesRepository();
      final imagesSearchRepository = MockImagesSearchRepository();
      final SearchScreenViewModel viewModel = SearchScreenViewModel(
        imagesSearchRepository: imagesSearchRepository,
        favoritesRepository: favoritesRepository,
      );
      final ImageUiModel imageToAddToFavorites = ImageUiModel(
        id: '1',
        width: 1024,
        height: 1024,
        alt: 'alt',
        imageThumbnail: 'imageThumbnail',
        originalImage: 'originalImage',
        largeImage: 'largeImage',
        isFavorite: false,
      );
      viewModel.state = SearchState.success([imageToAddToFavorites]);
      when(
        favoritesRepository.saveImageToFavorites(imageUiModel: imageToAddToFavorites),
      ).thenAnswer((_) async => FavoritesRepositorySuccessResult());

      // When
      await viewModel.toggleItemFavorite(imageUiModel: imageToAddToFavorites);

      // Then
      expect(viewModel.state.imagesItems.first.isFavorite, true);
    });

    test('When the item is already in favorites, should remove it from repository', () async {
      // Given
      final ImageUiModel imageToRemoveFromFavorites = ImageUiModel(
        id: '1',
        width: 1024,
        height: 1024,
        alt: 'alt',
        imageThumbnail: 'imageThumbnail',
        originalImage: 'originalImage',
        largeImage: 'largeImage',
        isFavorite: true,
      );
      final favoritesRepository = MockFavoritesRepository();
      when(favoritesRepository.watchFavoritesIds()).thenAnswer((_) => Stream<Set<String>>.value({'1'}));
      when(
        favoritesRepository.removeImageFromFavorites(imageId: imageToRemoveFromFavorites.id),
      ).thenAnswer((_) async => FavoritesRepositorySuccessResult());

      final imagesSearchRepository = MockImagesSearchRepository();
      final SearchScreenViewModel viewModel = SearchScreenViewModel(
        imagesSearchRepository: imagesSearchRepository,
        favoritesRepository: favoritesRepository,
      );
      await Future<void>.delayed(Duration.zero);
      viewModel.state = SearchState.success([imageToRemoveFromFavorites]);

      // When
      await viewModel.toggleItemFavorite(imageUiModel: imageToRemoveFromFavorites);

      // Then
      expect(viewModel.state.imagesItems.first.isFavorite, false);
    });
  });
}
