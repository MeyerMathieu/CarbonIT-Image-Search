import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/mappers/hive_images_mapper.dart';
import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:hive/hive.dart';

class HiveFavoritesRepository extends FavoritesRepository {
  static const favoritesBoxName = 'favorites';

  final Box<Map> favoritesBox;

  HiveFavoritesRepository({required this.favoritesBox});

  @override
  Future<void> saveImageToFavorites({required ImageEntity imageEntity}) async {
    final key = imageEntity.id.toString();
    await favoritesBox.put(key, HiveImagesMapper.serializeToMap(imageEntity: imageEntity));
  }

  @override
  Future<void> removeImageFromFavorites({required int imageId}) async {
    await favoritesBox.delete(imageId.toString());
  }

  @override
  Future<List<ImageEntity>> getFavorites() async =>
      favoritesBox.values
          .map(
            (Map<dynamic, dynamic> mapItem) =>
                HiveImagesMapper.deserializeFromMap(map: Map<String, dynamic>.from(mapItem)),
          )
          .toList();
}
