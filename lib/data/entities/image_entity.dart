import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';

class ImageEntity {
  final String id;
  final String url;
  final ImageSourceEntity source;
  // TODO : Add other fields

  ImageEntity({required this.id, required this.url, required this.source});
}
