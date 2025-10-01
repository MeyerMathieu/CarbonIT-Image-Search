import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';

class HiveImagesMapper {
  static Map<String, dynamic> serializeToMap({required ImageEntity imageEntity}) => <String, dynamic>{
    'id': imageEntity.id,
    'url': imageEntity.url,
    'src': <String, dynamic>{
      'original': imageEntity.source.original,
      'large': imageEntity.source.large,
      'medium': imageEntity.source.medium,
      'small': imageEntity.source.small,
      'portrait': imageEntity.source.portrait,
      'landscape': imageEntity.source.landscape,
      'tiny': imageEntity.source.tiny,
    },
  };

  static ImageEntity deserializeFromMap({required Map<String, dynamic> map}) => ImageEntity(
    id: map['id'].toString(),
    url: map['url'],
    source: ImageSourceEntity(
      original: map['src']['original'],
      large: map['src']['large'],
      medium: map['src']['medium'],
      small: map['src']['small'],
      portrait: map['src']['portrait'],
      landscape: map['src']['landscape'],
      tiny: map['src']['tiny'],
    ),
  );
}
