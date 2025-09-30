import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:carbon_it_images_search/presentation/view_models/search_screen_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_screen_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ImagesSearchRepository>()])
void main() {
  group('submitSearch', () {
    final ImagesSearchRepository imagesSearchRepository = MockImagesSearchRepository();
    final SearchScreenViewModel viewModel = SearchScreenViewModel(imagesSearchRepository: imagesSearchRepository);
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
        ImageEntity(id: 'id1', url: 'url1', source: imageSourceEntity),
        ImageEntity(id: 'id2', url: 'url2', source: imageSourceEntity),
      ];
      when(imagesSearchRepository.searchImages(search: searchValue)).thenAnswer((_) async => repositorySuccessResult);

      // When
      await viewModel.submitSearch(searchValue: searchValue);

      // Then
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, null);
      expect(viewModel.state.imagesItems.length, 2);
      expect(viewModel.state.imagesItems, repositorySuccessResult);
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
}
