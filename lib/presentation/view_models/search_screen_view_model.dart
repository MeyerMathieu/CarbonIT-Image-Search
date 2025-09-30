import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:carbon_it_images_search/presentation/states/search_states.dart';
import 'package:flutter/foundation.dart';

class SearchScreenViewModel extends ChangeNotifier {
  final ImagesSearchRepository imagesSearchRepository;
  SearchState state = const SearchState.idle();

  SearchScreenViewModel({required this.imagesSearchRepository});

  Future<void> submitSearch({required String searchValue}) async {
    // TODO : Handle empty searchValue
    state = SearchState.loading();
    notifyListeners();
    try {
      final List<String> results = await imagesSearchRepository.searchImages(search: searchValue);
      state = SearchState.success(results);
    } catch (error) {
      state = SearchState.errorMessage(error.toString());
    }
  }
}
