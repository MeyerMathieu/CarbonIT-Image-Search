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
  Future<FavoritesRepositoryResult> removeImageFromFavorites({required String imageId}) async {
    try {
      await favoritesBox.delete(imageId);
      return FavoritesRepositorySuccessResult();
    } catch (exception) {
      return FavoritesRepositoryErrorResult(exception);
    }
  }

  @override
  Future<List<ImageUiModel>> getFavorites() async =>
      favoritesBox.values
          .map((Map mapItem) => HiveImagesMapper.deserializeFromMap(map: Map<String, dynamic>.from(mapItem)))
          .toList();

  @override
  Stream<Set<String>> watchFavoritesIds() {
    return Stream<Set<String>>.multi((controller) {
      final subscription = favoritesBox.watch().listen((_) {
        controller.add(_currentFavoritesIds());
      }, onError: (error) => controller.addError(error));

      controller.add(_currentFavoritesIds());

      controller.onCancel = () => subscription.cancel();
    });
  }

  Set<String> _currentFavoritesIds() => favoritesBox.keys.map((key) => key.toString()).toSet();
}
