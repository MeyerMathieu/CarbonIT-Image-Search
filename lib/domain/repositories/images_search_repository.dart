import 'package:carbon_it_images_search/data/entities/image_entity.dart';

abstract class ImagesSearchRepository {
  // TODO : Handle locale
  Future<List<ImageEntity>> searchImages({required String search, int page = 1});
}
