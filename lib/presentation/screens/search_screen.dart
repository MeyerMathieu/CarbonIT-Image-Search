import 'package:carbon_it_images_search/injection.dart';
import 'package:carbon_it_images_search/presentation/models/image_ui_model.dart';
import 'package:carbon_it_images_search/presentation/states/search_states.dart';
import 'package:carbon_it_images_search/presentation/view_models/search_screen_view_model.dart';
import 'package:carbon_it_images_search/presentation/widgets/image_item_params.dart';
import 'package:carbon_it_images_search/presentation/widgets/image_item_widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _minPixelsBeforeLoadMoreItems = 500;

  final SearchScreenViewModel _searchScreenViewModel = getItInstance<SearchScreenViewModel>();
  final TextEditingController _searchTextEditingController = TextEditingController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchBar(
          searchScreenViewModel: _searchScreenViewModel,
          searchTextEditingController: _searchTextEditingController,
          onSearchSubmitted: (value) {
            _searchScreenViewModel.submitSearch(searchValue: value);
          },
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _searchScreenViewModel,
            builder:
                (BuildContext context, _) => _Body(
                  state: _searchScreenViewModel.state,
                  isLoadingMore: _searchScreenViewModel.isLoadingMore,
                  scrollController: _scrollController,
                  onFavoriteToggled: (ImageUiModel imageUiModel) {
                    _searchScreenViewModel.toggleItemFavorite(imageUiModel: imageUiModel);
                  },
                ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < _minPixelsBeforeLoadMoreItems &&
        !_searchScreenViewModel.isLoadingMore) {
      _searchScreenViewModel.loadMoreItems();
    }
  }
}

class _SearchBar extends StatelessWidget {
  final SearchScreenViewModel searchScreenViewModel;
  final TextEditingController searchTextEditingController;
  final ValueChanged<String> onSearchSubmitted;

  const _SearchBar({
    required this.searchScreenViewModel,
    required this.searchTextEditingController,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListenableBuilder(
        listenable: searchScreenViewModel,
        builder:
            (BuildContext context, _) => TextField(
              controller: searchTextEditingController,
              onSubmitted: (newValue) {
                _performSearch(context);
              },
              enabled: searchScreenViewModel.state is! SearchStateLoading,
              decoration: InputDecoration(
                hintText: 'Search images',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    tooltip: 'Search',
                    icon:
                        (searchScreenViewModel.state is SearchStateLoading)
                            ? Transform.scale(scale: 0.5, child: CircularProgressIndicator())
                            : Icon(Icons.search),
                    onPressed: () => _performSearch(context),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void _performSearch(BuildContext context) {
    // TODO : Handle empty field
    final textFieldContent = searchTextEditingController.text.trim();
    onSearchSubmitted(textFieldContent);
    _hideKeyboard(context);
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}

class _Body extends StatelessWidget {
  final SearchState state;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Function(ImageUiModel) onFavoriteToggled;

  const _Body({
    required this.state,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      SearchStateLoading _ => _LoadingState(),
      SearchStateSuccess successState => _SuccessState(
        images: successState.imagesItems,
        isLoadingMore: isLoadingMore,
        scrollController: scrollController,
        onFavoriteToggled: onFavoriteToggled,
      ),
      SearchStateEmpty emptyState => _EmptyState(searchQuery: emptyState.lastQuery),
      SearchStateError errorState => _ErrorState(message: errorState.errorMessage),
    };
  }
}

class _SuccessState extends StatelessWidget {
  static const double _bottomPadding = 24;
  static const double _paddingBetweenItems = 4;
  static const int _itemsPerLine = 2;

  final List<ImageUiModel> images;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Function(ImageUiModel) onFavoriteToggled;

  const _SuccessState({
    required this.images,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _itemsPerLine,
              crossAxisSpacing: _paddingBetweenItems,
              mainAxisSpacing: _paddingBetweenItems,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, index) {
              final ImageUiModel currentImage = images[index];
              return ImageItem(
                params: ImageItemParams.forSearchResults(imageUiModel: currentImage),
                onImageActionPerformed: () => onFavoriteToggled(currentImage),
              );
            },
            padding: EdgeInsets.only(bottom: _bottomPadding, left: _paddingBetweenItems, right: _paddingBetweenItems),
          ),
        ),
        if (isLoadingMore) ...[_LoadingMoreItem()],
      ],
    );
  }
}

class _LoadingMoreItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.transparent, child: Center(child: CircularProgressIndicator()));
}

class _EmptyState extends StatelessWidget {
  final String? searchQuery;

  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            (searchQuery != null)
                ? [Text('No item found for "$searchQuery"'), Text('Try a new search !')]
                : [Text('No item to display.'), Text('Search something to display images !')],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: CircularProgressIndicator());
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) => Center(child: Text('ERROR: $message'));
}
