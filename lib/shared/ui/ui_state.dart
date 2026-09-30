/// The presentation envelope every ViewModel exposes. Views pattern-match
/// exhaustively on the subtype.
sealed class UiState<T> {
  const UiState();
}

final class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

final class UiSuccess<T> extends UiState<T> {
  const UiSuccess(this.data);

  final T data;
}

final class UiError<T> extends UiState<T> {
  const UiError(this.error);

  final Object error;
}
