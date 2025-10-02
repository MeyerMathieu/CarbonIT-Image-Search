import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';

sealed class FavoritesState {
  const FavoritesState();
}

final class FavoritesStateLoading extends FavoritesState {}

final class FavoritesStateSuccess extends FavoritesState {
  final List<ImageUiModel> imagesItems;

  const FavoritesStateSuccess(this.imagesItems);
}

final class FavoritesStateEmpty extends FavoritesState {}

final class FavoritesStateError extends FavoritesState {
  final String errorMessage;

  const FavoritesStateError(this.errorMessage);
}
