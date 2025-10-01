import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

abstract class FavoritesRepository {
  Future<void> saveImageToFavorites({required ImageUiModel imageUiModel});
  Future<void> removeImageFromFavorites({required int imageId});
  Future<List<ImageUiModel>> getFavorites();
}
