import 'dart:async';

import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/domain/favorites_repository_result.dart';
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
  Set<String> _favoritesIds = {};

  SearchScreenViewModel({required this.imagesSearchRepository, required this.favoritesRepository}) {
    favoritesRepository.watchFavoritesIds().listen((ids) {
      _favoritesIds = ids;
    });
  }

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

  Future<void> toggleItemFavorite({required ImageUiModel imageUiModel}) async {
    _favoritesIds.contains(imageUiModel.id)
        ? _removeItemFromFavorite(imageUiModel: imageUiModel)
        : _addItemToFavorite(imageUiModel: imageUiModel);
  }

  Future<void> _addItemToFavorite({required ImageUiModel imageUiModel}) async {
    final repositoryResponse = await favoritesRepository.saveImageToFavorites(imageUiModel: imageUiModel);
    if (repositoryResponse is FavoritesRepositorySuccessResult) {
      final int imageItemIndex = state.imagesItems.indexOf(imageUiModel);
      state.imagesItems[imageItemIndex] = state.imagesItems[imageItemIndex].copyWith(isFavorite: true);
      notifyListeners();
    } else {
      // TODO : Display error snackbar ?
    }
  }

  Future<void> _removeItemFromFavorite({required ImageUiModel imageUiModel}) async {
    final repositoryResponse = await favoritesRepository.removeImageFromFavorites(imageId: imageUiModel.id);
    if (repositoryResponse is FavoritesRepositorySuccessResult) {
      final int imageItemIndex = state.imagesItems.indexOf(imageUiModel);
      state.imagesItems[imageItemIndex] = state.imagesItems[imageItemIndex].copyWith(isFavorite: false);
      notifyListeners();
    } else {
      // TODO : Display error snackbar ?
    }
  }
}
