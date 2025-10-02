import 'package:carbon_it_images_search/data/repositories/hive_favorites_repository.dart';
import 'package:carbon_it_images_search/data/repositories/pexels_images_search_repository.dart';
import 'package:carbon_it_images_search/domain/repositories/favorites_repository.dart';
import 'package:carbon_it_images_search/presentation/view_models/favorites_screen_view_model.dart';
import 'package:carbon_it_images_search/presentation/view_models/search_screen_view_model.dart';
import 'package:carbon_it_images_search/secrets.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'domain/repositories/images_search_repository.dart';

final getItInstance = GetIt.instance;

Future<void> setupInjection() async {
  // Hive
  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox<Map>(HiveFavoritesRepository.favoritesBoxName);

  // Repositories
  getItInstance.registerLazySingleton<ImagesSearchRepository>(
    () => PexelsImagesSearchRepository(dio: getItInstance<Dio>()),
  );
  getItInstance.registerLazySingleton<FavoritesRepository>(() => HiveFavoritesRepository(favoritesBox: favoritesBox));

  // ViewModels
  getItInstance.registerLazySingleton<SearchScreenViewModel>(
    () => SearchScreenViewModel(
      imagesSearchRepository: getItInstance<ImagesSearchRepository>(),
      favoritesRepository: getItInstance<FavoritesRepository>(),
    ),
  );
  getItInstance.registerLazySingleton<FavoritesScreenViewModel>(
    () => FavoritesScreenViewModel(favoritesRepository: getItInstance<FavoritesRepository>()),
  );

  // Misc
  final apiKey = Secrets.apiKey;
  // TODO : Get secrets from env: const String.fromEnvironment('PEXELS_API_KEY')
  final dio = Dio(
    BaseOptions(
      baseUrl: PexelsImagesSearchRepository.baseUrl,
      headers: {'Authorization': apiKey},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  getItInstance.registerLazySingleton<Dio>(() => dio);
}

Future<void> setupMockInjection() async {}
