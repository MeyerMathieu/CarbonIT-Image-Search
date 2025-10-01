import 'package:carbon_it_images_search/domain/favorites_repository_result.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

abstract class FavoritesRepository {
  Future<FavoritesRepositoryResult> saveImageToFavorites({required ImageUiModel imageUiModel});
  Future<FavoritesRepositoryResult> removeImageFromFavorites({required String imageId});
  Future<List<ImageUiModel>> getFavorites();
  Stream<Set<String>> watchFavoritesIds();
}
