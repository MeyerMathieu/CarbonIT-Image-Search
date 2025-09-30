abstract class ImagesSearchRepository {
  // TODO : Handle locale
  // TODO : Should return a list of images object
  Future<List<String>> searchImages({required String search, int page = 1});
}
