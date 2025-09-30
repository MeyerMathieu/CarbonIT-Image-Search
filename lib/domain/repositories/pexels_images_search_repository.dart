import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:dio/dio.dart';

class PexelsImagesSearchRepository extends ImagesSearchRepository {
  static const String baseUrl = 'https://api.pexels.com/v1/';
  static const String _searchEndpoint = 'search/';
  static const int _resultsPerPage = 12;

  final Dio dio;

  PexelsImagesSearchRepository({required this.dio});

  @override
  Future<List<String>> searchImages({required String search, int page = 1}) async {
    final requestResult = await dio.get(
      _searchEndpoint,
      queryParameters: {'query': search, 'page': page, 'per_page': _resultsPerPage},
    );

    final requestData = requestResult.data as Map<String, dynamic>;
    final pictures = requestData['photos'] as List<dynamic>;

    final List<String> result =
        pictures.map((final pictureItem) => (pictureItem as Map<String, dynamic>)['url'] as String).toList();
    return result;
  }
}
