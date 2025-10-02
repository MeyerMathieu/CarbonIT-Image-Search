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
  SearchState state = SearchStateEmpty();
  Set<String> _favoritesIds = {};
  StreamSubscription<Set<String>>? _favoritesIdsStreamSubscription;

  SearchScreenViewModel({required this.imagesSearchRepository, required this.favoritesRepository}) {
    _favoritesIdsStreamSubscription = favoritesRepository.watchFavoritesIds().listen((ids) {
      _favoritesIds = ids;
      _refreshFavoritesOnCurrentList();
    });
  }

  Future<void> submitSearch({required String searchValue}) async {
    state = SearchStateLoading();
    notifyListeners();
    try {
      final List<ImageEntity> repositoryResults = await imagesSearchRepository.searchImages(search: searchValue);
      final List<ImageUiModel> imagesToDisplay =
          repositoryResults
              .map(
                (ImageEntity imageEntity) => ImageUiModelMapper.mapImageEntityToImageUiModel(imageEntity: imageEntity),
              )
              .toList();
      state =
          (imagesToDisplay.isEmpty) ? SearchStateEmpty(lastQuery: searchValue) : SearchStateSuccess(imagesToDisplay);
      notifyListeners();
    } catch (error) {
      state = SearchStateError(error.toString());
      notifyListeners();
    }
  }

  Future<void> toggleItemFavorite({required ImageUiModel imageUiModel}) async {
    _favoritesIds.contains(imageUiModel.id)
        ? _removeItemFromFavorite(imageToRemove: imageUiModel)
        : _addItemToFavorite(imageToAdd: imageUiModel);
  }

  Future<void> _addItemToFavorite({required ImageUiModel imageToAdd}) async {
    final repositoryResponse = await favoritesRepository.saveImageToFavorites(
      imageUiModel: imageToAdd.copyWith(isFavorite: true),
    );
    if (repositoryResponse is FavoritesRepositorySuccessResult) {
      final List<ImageUiModel> imagesDisplayed = (state as SearchStateSuccess).imagesItems;
      final int imageItemIndex = imagesDisplayed.indexWhere(
        (ImageUiModel imageUiModel) => imageUiModel.id == imageToAdd.id,
      );
      imagesDisplayed[imageItemIndex] = imagesDisplayed[imageItemIndex].copyWith(isFavorite: true);
      state = SearchStateSuccess(imagesDisplayed);
      notifyListeners();
    } else {
      // TODO : Display error snackbar ?
    }
  }

  Future<void> _removeItemFromFavorite({required ImageUiModel imageToRemove}) async {
    final FavoritesRepositoryResult repositoryResponse = await favoritesRepository.removeImageFromFavorites(
      imageId: imageToRemove.id,
    );
    if (repositoryResponse is FavoritesRepositorySuccessResult) {
      final List<ImageUiModel> imagesDisplayed = (state as SearchStateSuccess).imagesItems;
      final int imageItemIndex = imagesDisplayed.indexWhere(
        (ImageUiModel imageUiModel) => imageUiModel.id == imageToRemove.id,
      );
      imagesDisplayed[imageItemIndex] = imagesDisplayed[imageItemIndex].copyWith(isFavorite: false);
      state = SearchStateSuccess(imagesDisplayed);
      notifyListeners();
    } else {
      // TODO : Display error snackbar ?
    }
  }

  void _refreshFavoritesOnCurrentList() {
    if (state is! SearchStateSuccess || (state as SearchStateSuccess).imagesItems.isEmpty) {
      return;
    }
    final updatedImages =
        (state as SearchStateSuccess).imagesItems
            .map(
              (ImageUiModel imageUiModel) => imageUiModel.copyWith(isFavorite: _favoritesIds.contains(imageUiModel.id)),
            )
            .toList();
    state = SearchStateSuccess(updatedImages);
    notifyListeners();
  }

  @override
  void dispose() {
    _favoritesIdsStreamSubscription?.cancel();
    super.dispose();
  }
}
