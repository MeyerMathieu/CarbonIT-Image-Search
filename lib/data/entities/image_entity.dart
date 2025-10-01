import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String url;
  final ImageSourceEntity source;
  // TODO : Add other fields

  const ImageEntity({required this.id, required this.url, required this.source});

  @override
  List<Object?> get props => [id, url, source];
}
