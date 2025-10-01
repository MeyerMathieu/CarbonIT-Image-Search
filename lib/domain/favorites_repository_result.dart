sealed class FavoritesRepositoryResult {
  const FavoritesRepositoryResult();
}

class FavoritesRepositorySuccessResult extends FavoritesRepositoryResult {
  const FavoritesRepositorySuccessResult();
}

class FavoritesRepositoryErrorResult extends FavoritesRepositoryResult {
  final Object error;

  const FavoritesRepositoryErrorResult(this.error);
}
