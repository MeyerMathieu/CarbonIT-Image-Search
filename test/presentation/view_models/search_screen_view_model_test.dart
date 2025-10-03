import 'dart:async';

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

import '../../tests_utils.dart';
import 'search_screen_view_model_test.mocks.dart';

// TODO : Move mocks in another file
@GenerateNiceMocks([MockSpec<ImagesSearchRepository>(), MockSpec<FavoritesRepository>()])
void main() {
  final ImageSourceEntity testImageSourceEntity = ImageSourceEntity(
    original: 'original',
    large: 'large',
    medium: 'medium',
    small: 'small',
    portrait: 'portrait',
    landscape: 'landscape',
    tiny: 'tiny',
  );

  group('submitSearch', () {
    final ImagesSearchRepository imagesSearchRepository = MockImagesSearchRepository();
    final FavoritesRepository favoritesRepository = MockFavoritesRepository();
    final SearchScreenViewModel viewModel = SearchScreenViewModel(
      imagesSearchRepository: imagesSearchRepository,
      favoritesRepository: favoritesRepository,
    );
    final String searchValue = 'searchValue';

    test('When a search with empty field is submitted, should do nothing', () async {
      // Given
      final viewModel = SearchScreenViewModel(
        imagesSearchRepository: imagesSearchRepository,
        favoritesRepository: favoritesRepository,
      );
      final previousState = viewModel.state;

      // When
      await viewModel.submitSearch(searchValue: '');

      // Then
      expect(viewModel.state, same(previousState));
      verifyZeroInteractions(imagesSearchRepository);
    });

    test('When a search is submitted and repository returns a list of items, should set state items', () async {
      // Given
      final List<ImageEntity> repositorySuccessResult = [
        ImageEntity(id: 'id1', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
        ImageEntity(id: 'id2', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
      ];
      final List<ImageUiModel> resultImagesItems = [
        buildTestImageUiModel(id: repositorySuccessResult.first.id),
        buildTestImageUiModel(id: repositorySuccessResult.last.id),
      ];
      when(imagesSearchRepository.searchImages(search: searchValue)).thenAnswer((_) async => repositorySuccessResult);

      // When
      await viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state, isA<SearchStateSuccess>());
      expect((viewModel.state as SearchStateSuccess).imagesItems.length, 2);
      expect((viewModel.state as SearchStateSuccess).imagesItems, resultImagesItems);
    });

    test('When a search is submitted and repository returns an empty list, should set state items', () async {
      // Given
      when(imagesSearchRepository.searchImages(search: searchValue)).thenAnswer((_) async => []);

      // When
      await viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state, isA<SearchStateEmpty>());
      expect((viewModel.state as SearchStateEmpty).lastQuery, searchValue);
    });

    test('When a search is submitted, should set state to loading', () {
      // When
      viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state, isA<SearchStateLoading>());
    });

    test('When the repository throws an error, should set state to error', () async {
      // Given
      final String repositoryErrorMessage = 'Error';
      when(imagesSearchRepository.searchImages(search: searchValue)).thenThrow(repositoryErrorMessage);

      // When
      await viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state, isA<SearchStateError>());
    });
  });

  group('loadMoreItems', () {
    final ImagesSearchRepository imagesSearchRepository = MockImagesSearchRepository();
    final FavoritesRepository favoritesRepository = MockFavoritesRepository();
    final SearchScreenViewModel viewModel = SearchScreenViewModel(
      imagesSearchRepository: imagesSearchRepository,
      favoritesRepository: favoritesRepository,
    );
    final String searchValue = 'searchValue';

    test(
      'When loading more items, if repository returns successfully, should add new items to SearchSuccessState list',
      () async {
        // Given
        final List<ImageEntity> originalRequestSuccessResult = [
          ImageEntity(id: 'id1', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
          ImageEntity(id: 'id2', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
        ];
        final List<ImageEntity> repositorySuccessResult = [
          ImageEntity(id: 'id3', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
          ImageEntity(id: 'id4', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
        ];
        final List<ImageUiModel> resultImagesItems = [
          buildTestImageUiModel(id: 'id1'),
          buildTestImageUiModel(id: 'id2'),
          buildTestImageUiModel(id: 'id3'),
          buildTestImageUiModel(id: 'id4'),
        ];
        when(
          imagesSearchRepository.searchImages(search: searchValue, page: 1),
        ).thenAnswer((_) async => originalRequestSuccessResult);
        when(
          imagesSearchRepository.searchImages(search: searchValue, page: 2),
        ).thenAnswer((_) async => repositorySuccessResult);
        await viewModel.submitSearch(searchValue: searchValue);

        // When
        await viewModel.loadMoreItems();

        // Then
        expect(viewModel.state, isA<SearchStateSuccess>());
        expect((viewModel.state as SearchStateSuccess).imagesItems.length, 4);
        expect((viewModel.state as SearchStateSuccess).imagesItems, resultImagesItems);
      },
    );

    test(
      'When loading more items, if repository has returned successfully with empty list, should do nothing and do not call repository again next time',
      () async {
        // Given
        when(imagesSearchRepository.searchImages(search: searchValue, page: 1)).thenAnswer((_) async => []);
        when(imagesSearchRepository.searchImages(search: searchValue, page: 2)).thenAnswer((_) async => []);
        await viewModel.submitSearch(searchValue: searchValue);
        reset(imagesSearchRepository);

        // When
        await viewModel.loadMoreItems();

        // Then
        expect(viewModel.state, isA<SearchStateEmpty>());
        verifyNever(imagesSearchRepository.searchImages(search: searchValue, page: 2));
      },
    );

    test('When loading more items, if repository returns a failure, should still keep success state', () async {
      // Given
      final List<ImageEntity> originalRequestSuccessResult = [
        ImageEntity(id: 'id1', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
        ImageEntity(id: 'id2', width: 1024, height: 1024, alt: 'alt', source: testImageSourceEntity),
      ];
      when(
        imagesSearchRepository.searchImages(search: searchValue, page: 1),
      ).thenAnswer((_) async => originalRequestSuccessResult);
      when(imagesSearchRepository.searchImages(search: searchValue, page: 2)).thenThrow((_) async => []);
      await viewModel.submitSearch(searchValue: searchValue);

      // When
      await viewModel.loadMoreItems();

      // Then
      expect(viewModel.state, isA<SearchStateSuccess>());
      expect((viewModel.state as SearchStateSuccess).imagesItems.length, 2);
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
      final ImageUiModel imageToAddToFavorites = buildTestImageUiModel(id: '1');
      viewModel.state = SearchStateSuccess([imageToAddToFavorites]);
      when(
        favoritesRepository.saveImageToFavorites(imageUiModel: imageToAddToFavorites.copyWith(isFavorite: true)),
      ).thenAnswer((_) async => FavoritesRepositorySuccessResult());

      // When
      await viewModel.toggleItemFavorite(imageUiModel: imageToAddToFavorites);

      // Then
      expect(viewModel.state, isA<SearchStateSuccess>());
      expect((viewModel.state as SearchStateSuccess).imagesItems.first.isFavorite, true);
    });

    test('When the item is already in favorites, should remove it from repository', () async {
      // Given
      final List<ImageUiModel> searchItems = [
        buildTestImageUiModel(id: '1', isFavorite: true),
        buildTestImageUiModel(id: '2'),
      ];
      final favoritesRepository = MockFavoritesRepository();
      final imagesSearchRepository = MockImagesSearchRepository();

      final controller = StreamController<Set<String>>();
      when(favoritesRepository.watchFavoritesIds()).thenAnswer((_) => controller.stream);
      when(
        favoritesRepository.removeImageFromFavorites(imageId: searchItems.first.id),
      ).thenAnswer((_) async => FavoritesRepositorySuccessResult());
      final SearchScreenViewModel viewModel = SearchScreenViewModel(
        imagesSearchRepository: imagesSearchRepository,
        favoritesRepository: favoritesRepository,
      );
      viewModel.state = SearchStateSuccess(searchItems);
      controller.add(<String>{'1'});
      await Future<void>.delayed(Duration.zero);

      // When
      await viewModel.toggleItemFavorite(imageUiModel: searchItems.first);

      // Then
      expect(viewModel.state, isA<SearchStateSuccess>());
      expect((viewModel.state as SearchStateSuccess).imagesItems.first.isFavorite, false);
    });
  });

  group('Favorite removed from another screen', () {
    test('When a favorite is removed from repository, should update list item with new isFavorite value', () async {
      // Given
      final favoritesRepository = MockFavoritesRepository();
      final imagesSearchRepository = MockImagesSearchRepository();
      final favoritesStreamController = StreamController<Set<String>>();
      when(favoritesRepository.watchFavoritesIds()).thenAnswer((_) => favoritesStreamController.stream);
      final viewModel = SearchScreenViewModel(
        imagesSearchRepository: imagesSearchRepository,
        favoritesRepository: favoritesRepository,
      );
      viewModel.state = SearchStateSuccess([
        buildTestImageUiModel(id: '1', isFavorite: true),
        buildTestImageUiModel(id: '2', isFavorite: true),
      ]);

      // When
      favoritesStreamController.add(<String>{});
      await Future.delayed(Duration.zero);

      // Then
      expect(viewModel.state, isA<SearchStateSuccess>());
      expect((viewModel.state as SearchStateSuccess).imagesItems.first.isFavorite, false);
    });
  });
}
