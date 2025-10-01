import 'package:carbon_it_images_search/data/entities/image_entity.dart';

abstract class FavoritesRepository {
  Future<void> saveImageToFavorites({required ImageEntity imageEntity});
  Future<void> removeImageFromFavorites({required int imageId});
  Future<List<ImageEntity>> getFavorites();
}
