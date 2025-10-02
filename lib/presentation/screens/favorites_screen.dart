import 'package:carbon_it_images_search/injection.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/favorites_states.dart';
import 'package:carbon_it_images_search/presentation/view_models/favorites_screen_view_model.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

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
  final Function(ImageUiModel imageUiModel) onFavoriteToggled;

  const _Body({required this.state, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      FavoritesStateSuccess successState => _SuccessState(
        favoritesImagesList: successState.imagesItems,
        onFavoriteToggled: onFavoriteToggled,
      ),
      FavoritesStateLoading _ => _Loading(),
      FavoritesStateEmpty _ => _Empty(),
      FavoritesStateError errorState => _Error(message: errorState.errorMessage),
    };
  }
}

// TODO : set as common widget
class _ImageItem extends StatelessWidget {
  final ImageUiModel image;
  final Function(ImageUiModel) onFavoriteToggled;

  const _ImageItem({required this.image, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => onFavoriteToggled(image),
      child: AspectRatio(
        aspectRatio: image.width / image.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                image.largeImage,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.black12),
                      const Center(
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    ],
                  );
                },
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 24),
                    ),
                gaplessPlayback: true,
              ),
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: () => onFavoriteToggled(image),
                  child:
                      (image.isFavorite)
                          ? Icon(Icons.bookmark, color: Colors.red)
                          : Icon(Icons.bookmark_add_outlined, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        return _ImageItem(
          image: favoritesImagesList[index],
          onFavoriteToggled: (_) => onFavoriteToggled(favoritesImagesList[index]),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('No item to display.'), Text('Add your first favorite image from search screen !')],
        // TODO : Bonus - Bouton redirect to searchScreen
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
