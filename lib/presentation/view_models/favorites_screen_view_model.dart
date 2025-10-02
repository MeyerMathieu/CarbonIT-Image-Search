import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/favorites_states.dart';
import 'package:flutter/foundation.dart';

class FavoritesScreenViewModel extends ChangeNotifier {
  final FavoritesRepository favoritesRepository;

  FavoritesState state = FavoritesStateIdle();

  FavoritesScreenViewModel({required this.favoritesRepository});

  Future<void> loadFavorites() async {
    state = FavoritesStateLoading();
    notifyListeners();

    try {
      final List<ImageUiModel> favoritesList = await favoritesRepository.getFavorites();
      state = (favoritesList.isEmpty) ? FavoritesStateEmpty() : FavoritesStateSuccess(favoritesList);
      notifyListeners();
    } catch (error) {
      state = FavoritesStateError(error.toString());
    }
  }

  Future<void> removeImageFromFavorites() async {
    // TODO
  }
}
