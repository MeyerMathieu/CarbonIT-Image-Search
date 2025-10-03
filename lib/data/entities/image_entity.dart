import 'package:carbon_it_images_search/data/entities/image_source_entity.dart';
import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final int width;
  final int height;
  final String? alt;
  final ImageSourceEntity source;

  const ImageEntity({required this.id, required this.width, required this.height, required this.source, this.alt});

  @override
  List<Object?> get props => [id, width, height, source, alt];
}
