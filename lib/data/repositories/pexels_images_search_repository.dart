import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/mappers/pexels_images_mapper.dart';
import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:dio/dio.dart';

class PexelsImagesSearchRepository extends ImagesSearchRepository {
  static const String baseUrl = 'https://api.pexels.com/v1/';
  static const String _searchEndpoint = 'search/';
  static const int _resultsPerPage = 12;

  final Dio dio;

  PexelsImagesSearchRepository({required this.dio});

  @override
  Future<List<ImageEntity>> searchImages({required String search, int page = 1}) async {
    final Response<dynamic> requestResult = await dio.get(
      _searchEndpoint,
      queryParameters: {'query': search, 'page': page, 'per_page': _resultsPerPage},
    );

    return PexelsImagesMapper.parseJson(requestResult.data as Map<String, dynamic>);
  }
}
