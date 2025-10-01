import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/domain/repositories/images_search_repository.dart';
import 'package:carbon_it_images_search/presentation/mappers/image_ui_model_mapper.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/search_states.dart';
import 'package:flutter/foundation.dart';

class SearchScreenViewModel extends ChangeNotifier {
  final ImagesSearchRepository imagesSearchRepository;
  final FavoritesRepository favoritesRepository;
  SearchState state = const SearchState.idle();

  SearchScreenViewModel({required this.imagesSearchRepository, required this.favoritesRepository});

  Future<void> submitSearch({required String searchValue}) async {
    state = state.copyWith(isLoading: true, imagesItems: [], errorMessage: null, lastQuery: searchValue);
    notifyListeners();
    try {
      final List<ImageEntity> repositoryResults = await imagesSearchRepository.searchImages(search: searchValue);
      final List<ImageUiModel> imagesToDisplay =
          repositoryResults
              .map(
                (ImageEntity imageEntity) => ImageUiModelMapper.mapImageEntityToImageUiModel(imageEntity: imageEntity),
              )
              .toList();
      state = state.copyWith(
        isLoading: false,
        imagesItems: imagesToDisplay,
        errorMessage: null,
        lastQuery: searchValue,
      );
      notifyListeners();
    } catch (error) {
      state = state.copyWith(isLoading: false, imagesItems: [], errorMessage: error.toString(), lastQuery: searchValue);
      notifyListeners();
    }
  }

  Future<void> toggleItemFavorite({required ImageUiModel imageEntity}) async {
    // TODO
  }
}
