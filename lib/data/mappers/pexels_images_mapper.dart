import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';

class PexelsImagesMapper {
  static List<ImageEntity> parseJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> photos = (json['photos'] as List).cast<Map<String, dynamic>>();

    return photos.map((Map<String, dynamic> photo) {
      final src = (photo['src'] as Map).cast<String, dynamic>();

      return ImageEntity(
        id: photo['id'].toString(),
        url: photo['url'],
        source: ImageSourceEntity(
          original: src['original'],
          large: src['large'],
          medium: src['medium'],
          small: src['small'],
          portrait: src['portrait'],
          landscape: src['landscape'],
          tiny: src['tiny'],
        ),
      );
    }).toList();
  }
}
