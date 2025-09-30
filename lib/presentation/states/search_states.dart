import 'package:carbon_it_images_search/data/entities/image_entity.dart';

class SearchState {
  final bool isLoading;
  final List<ImageEntity> imagesItems;
  final String? errorMessage;

  const SearchState._({this.isLoading = false, this.imagesItems = const [], this.errorMessage});

  const SearchState.idle() : this._();
  const SearchState.loading() : this._(isLoading: true);
  const SearchState.success(List<ImageEntity> imagesItems) : this._(imagesItems: imagesItems);
  const SearchState.errorMessage(String errorMessage) : this._(errorMessage: errorMessage);
}
