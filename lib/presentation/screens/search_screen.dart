import 'package:carbon_it_images_search/data/entities/image_entity.dart';
import 'package:carbon_it_images_search/injection.dart';
import 'package:carbon_it_images_search/presentation/view_models/search_screen_view_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchScreenViewModel _searchScreenViewModel = getItInstance<SearchScreenViewModel>();
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CarbonIT Images search')),
      body: Column(
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
              builder: (BuildContext context, _) => _Body(images: _searchScreenViewModel.state.imagesItems),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }
}

class _SearchBar extends StatelessWidget {
  final SearchScreenViewModel searchScreenViewModel;
  final TextEditingController searchTextEditingController;
  final Function(String) onSearchSubmitted;

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
              enabled: !searchScreenViewModel.state.isLoading,
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
                        (searchScreenViewModel.state.isLoading)
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
    final textFieldContent = searchTextEditingController.text.trim();
    onSearchSubmitted(textFieldContent);
    _hideKeyboard(context);
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}

class _Body extends StatelessWidget {
  static const double _paddingBetweenItems = 4;
  static const int _itemsPerLine = 2;

  final List<ImageEntity> images;

  const _Body({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _EmptyState();
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerLine,
        crossAxisSpacing: _paddingBetweenItems,
        mainAxisSpacing: _paddingBetweenItems,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, index) => _ImageItem(image: images[index]),
      padding: EdgeInsets.all(_paddingBetweenItems),
    );
  }
}

class _ImageItem extends StatelessWidget {
  final ImageEntity image;

  const _ImageItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.network(
        image.source.tiny,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black12),
              const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('No item to display.'), Text('Make a search to display images !')],
      ),
    );
  }
}
