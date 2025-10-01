import 'package:carbon_it_images_search/data/repositories/pexels_images_search_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pexels_images_search_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('searchImages', () {
    test('When search is performed, the repository should use Dio with correct query arguments', () async {
      // Given
      final dio = MockDio();
      final searchQueryParameter = 'cats';
      final pageQueryParameter = 2;
      when(dio.get('search/', queryParameters: anyNamed('queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: 'search/'),
          data: {
            'photos': [
              {
                'id': 1,
                'url': 'x',
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
            ],
          },
        ),
      );
      final repository = PexelsImagesSearchRepository(dio: dio);

      // When
      final result = await repository.searchImages(search: searchQueryParameter, page: pageQueryParameter);

      // Then
      verify(
        dio.get(
          'search/',
          queryParameters: {'query': searchQueryParameter, 'page': pageQueryParameter, 'per_page': 12},
        ),
      ).called(1);
      expect(result, isNotEmpty);
    });
  });
}
