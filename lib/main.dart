import 'package:carbon_it_images_search/presentation/screens/home_screen.dart';
import 'package:carbon_it_images_search/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Carbon IT - Images search', theme: AppTheme.buildDarkTheme(), home: const HomeScreen());
  }
}
