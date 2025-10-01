import 'package:carbon_it_images_search/data/mappers/hive_images_mapper.dart';
import 'package:carbon_it_images_search/domain/favorites_repository_result.dart';
import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveFavoritesRepository extends FavoritesRepository {
  static const favoritesBoxName = 'favorites';

  final Box<Map> favoritesBox;

  HiveFavoritesRepository({required this.favoritesBox});

  @override
  Future<FavoritesRepositoryResult> saveImageToFavorites({required ImageUiModel imageUiModel}) async {
    final key = imageUiModel.id.toString();
    try {
      await favoritesBox.put(key, HiveImagesMapper.serializeToMap(imageUiModel: imageUiModel));
      return FavoritesRepositorySuccessResult();
    } catch (exception) {
      return FavoritesRepositoryErrorResult(exception);
    }
  }

  @override
  Future<FavoritesRepositoryResult> removeImageFromFavorites({required int imageId}) async {
    try {
      await favoritesBox.delete(imageId.toString());
      return FavoritesRepositorySuccessResult();
    } catch (exception) {
      return FavoritesRepositoryErrorResult(exception);
    }
  }

  @override
  Future<List<ImageUiModel>> getFavorites() async =>
      favoritesBox.values
          .map(
            (Map<dynamic, dynamic> mapItem) =>
                HiveImagesMapper.deserializeFromMap(map: Map<String, dynamic>.from(mapItem)),
          )
          .toList();
}
