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
          _SearchResults(),
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
