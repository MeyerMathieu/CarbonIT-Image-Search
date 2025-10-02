import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

sealed class SearchState {
  const SearchState();
}

final class SearchStateLoading extends SearchState {}

final class SearchStateSuccess extends SearchState {
  final List<ImageUiModel> imagesItems;

  const SearchStateSuccess(this.imagesItems);
}

final class SearchStateEmpty extends SearchState {
  final String? lastQuery;

  const SearchStateEmpty({this.lastQuery});
}

final class SearchStateError extends SearchState {
  final String errorMessage;

  const SearchStateError(this.errorMessage);
}
