import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:carbon_it_images_search/presentation/states/search_states.dart';
import 'package:flutter/foundation.dart';

class SearchScreenViewModel extends ChangeNotifier {
  final ImagesSearchRepository imagesSearchRepository;
  SearchState state = const SearchState.idle();

  SearchScreenViewModel({required this.imagesSearchRepository});

  Future<void> submitSearch({required String searchValue}) async {
    state = state.copyWith(isLoading: true, imagesItems: [], errorMessage: null, lastQuery: searchValue);
    notifyListeners();
    try {
      final List<ImageEntity> results = await imagesSearchRepository.searchImages(search: searchValue);
      state = state.copyWith(isLoading: false, imagesItems: results, errorMessage: null, lastQuery: searchValue);
      notifyListeners();
    } catch (error) {
      state = state.copyWith(isLoading: false, imagesItems: [], errorMessage: error.toString(), lastQuery: searchValue);
      notifyListeners();
    }
  }

  Future<void> addItemToFavorites({required ImageEntity imageEntity}) async {
    // TODO
  }
}
