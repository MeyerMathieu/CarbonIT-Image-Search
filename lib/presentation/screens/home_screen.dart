import 'package:carbon_it_images_search/presentation/screens/favorites_screen.dart';
import 'package:carbon_it_images_search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(bottom: TabBar(controller: _tabController, tabs: [Tab(text: 'Search'), Tab(text: 'Favorites')])),
      body: TabBarView(controller: _tabController, children: [SearchScreen(), FavoritesScreen()]),
    );
  }
}
