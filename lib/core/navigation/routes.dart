/// Route names. Features navigate by name and never import each other's
/// screens; the route table lives in `lib/app/`.
abstract final class Routes {
  static const login = '/login';
  static const cards = '/cards';

  /// Argument: the card id, as a [String].
  static const cardDetail = '/cards/detail';
}
