import 'package:carbon_it_images_search/injection.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/favorites_states.dart';
import 'package:carbon_it_images_search/presentation/view_models/favorites_screen_view_model.dart';
import 'package:carbon_it_images_search/presentation/widgets/image_item_params.dart';
import 'package:carbon_it_images_search/presentation/widgets/image_item_widget.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final Function() goToSearchTab;

  const FavoritesScreen({super.key, required this.goToSearchTab});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesScreenViewModel _viewModel = getItInstance<FavoritesScreenViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (BuildContext context, Widget? _) {
        return _Body(
          state: _viewModel.state,
          goToSearch: widget.goToSearchTab,
          onFavoriteToggled: (ImageUiModel imageUiModel) {
            _viewModel.removeImageFromFavorites(imageUiModel: imageUiModel);
          },
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final FavoritesState state;
  final Function() goToSearch;
  final Function(ImageUiModel imageUiModel) onFavoriteToggled;

  const _Body({required this.state, required this.goToSearch, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      FavoritesStateSuccess successState => _SuccessState(
        favoritesImagesList: successState.imagesItems,
        onFavoriteToggled: onFavoriteToggled,
      ),
      FavoritesStateLoading _ => _Loading(),
      FavoritesStateEmpty _ => _Empty(goToSearch: goToSearch),
      FavoritesStateError errorState => _Error(message: errorState.errorMessage),
    };
  }
}

class _SuccessState extends StatelessWidget {
  final List<ImageUiModel> favoritesImagesList;
  final Function(ImageUiModel imageUiModel) onFavoriteToggled;

  const _SuccessState({required this.favoritesImagesList, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: favoritesImagesList.length,
      separatorBuilder: (BuildContext context, int index) {
        return Padding(padding: EdgeInsets.only(top: 8));
      },
      itemBuilder: (BuildContext context, int index) {
        final ImageUiModel imageItem = favoritesImagesList[index];
        return ImageItem(
          params: ImageItemParams.forFavoritesList(imageUiModel: imageItem),
          onImageActionPerformed: () => onFavoriteToggled(imageItem),
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: CircularProgressIndicator());
}

class _Empty extends StatelessWidget {
  final Function() goToSearch;

  const _Empty({required this.goToSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24,
        children: [
          Text('No item to display.'),
          Text('Add your first favorite image from search screen !'),
          ElevatedButton(onPressed: goToSearch, child: Text('Go to search')),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final String message;

  const _Error({required this.message});

  @override
  Widget build(BuildContext context) => Center(child: Text('ERROR: $message'));
}
