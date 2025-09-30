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
      appBar: AppBar(title: Text('TEST')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextField(
              controller: _searchTextEditingController,
              onSubmitted: (value) {
                _searchScreenViewModel.submitSearch(searchValue: value);
              },
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _searchScreenViewModel,
              builder: (BuildContext context, _) => _SearchResults(images: _searchScreenViewModel.state.imagesItems),
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

class _SearchResults extends StatelessWidget {
  final List<ImageEntity> images;

  const _SearchResults({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container();
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: images.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(padding: EdgeInsets.all(8), child: Image.network(images[index].source.tiny));
      },
    );
  }
}
