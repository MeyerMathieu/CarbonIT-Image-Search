class SearchState {
  final bool isLoading;
  final List<String> imagesItems;
  final String? errorMessage;

  const SearchState._({this.isLoading = false, this.imagesItems = const [], this.errorMessage});

  const SearchState.idle() : this._();
  const SearchState.loading() : this._(isLoading: true);
  const SearchState.success(List<String> imagesItems) : this._(imagesItems: imagesItems);
  const SearchState.errorMessage(String errorMessage) : this._(errorMessage: errorMessage);
}
