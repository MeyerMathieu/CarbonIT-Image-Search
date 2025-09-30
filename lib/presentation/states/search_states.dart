import 'package:carbon_it_images_search/data/entities/image_entity.dart';

class SearchState {
  final bool isLoading;
  final List<ImageEntity> imagesItems;
  final String? errorMessage;
  final String? lastQuery;

  const SearchState._({this.isLoading = false, this.imagesItems = const [], this.errorMessage, this.lastQuery});

  const SearchState.idle() : this._(lastQuery: null);
  const SearchState.loading(String searchQuery) : this._(isLoading: true, lastQuery: searchQuery);
  const SearchState.success(List<ImageEntity> imagesItems) : this._(imagesItems: imagesItems);
  const SearchState.errorMessage(String errorMessage) : this._(errorMessage: errorMessage);

  SearchState copyWith({bool? isLoading, List<ImageEntity>? imagesItems, String? errorMessage, String? lastQuery}) {
    return SearchState._(
      isLoading: isLoading ?? this.isLoading,
      imagesItems: imagesItems ?? this.imagesItems,
      errorMessage: errorMessage,
      lastQuery: lastQuery ?? this.lastQuery,
    );
  }
}
