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
  final TextEditingController searchTextEditingController;
  final Function(String) onSearchSubmitted;

  const _SearchBar({required this.searchTextEditingController, required this.onSearchSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextField(controller: searchTextEditingController, onSubmitted: onSearchSubmitted),
    );
  }
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
      child: Image.network(image.source.tiny, fit: BoxFit.cover),
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
