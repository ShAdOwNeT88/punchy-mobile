import 'package:flutter/foundation.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/shared/ui/ui_state.dart';

enum CardFilter {
  all,
  memberships,
  loyalty;

  bool accepts(DigitalCard card) => switch (this) {
    all => true,
    memberships => card.program.isMembership,
    loyalty => !card.program.isMembership,
  };
}

class CardsViewModel extends ChangeNotifier {
  CardsViewModel(this._repository, this._session);

  final CardsRepository _repository;
  final SessionController _session;

  UiState<List<DigitalCard>> _state = const UiLoading();
  UiState<List<DigitalCard>> _visible = const UiLoading();

  /// The cards that pass the current [filter].
  UiState<List<DigitalCard>> get state => _visible;

  CardFilter _filter = CardFilter.all;
  CardFilter get filter => _filter;

  /// Whether the user holds cards of more than one kind, so a filter helps.
  bool get canFilter => switch (_state) {
    UiSuccess(:final data) =>
      data.any(CardFilter.memberships.accepts) &&
          data.any(CardFilter.loyalty.accepts),
    _ => false,
  };

  void setFilter(CardFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    _emit(_state);
  }

  /// First name of the signed-in user, or null when unknown.
  String? get firstName {
    final name = _session.current?.firstName;
    return name == null || name.isEmpty ? null : name;
  }

  Future<void> load() => _fetch(forceRefresh: false);

  Future<void> refresh() => _fetch(forceRefresh: true);

  Future<void> retry() {
    _emit(const UiLoading());
    return _fetch(forceRefresh: true);
  }

  Future<void> logout() async {
    _repository.clear();
    await _session.end();
  }

  Future<void> _fetch({required bool forceRefresh}) async {
    try {
      final cards = await _repository.getCards(forceRefresh: forceRefresh);
      _emit(UiSuccess(cards));
    } on Object catch (e) {
      // Keep showing cards already on screen when a refresh fails.
      if (_state is! UiSuccess) _emit(UiError(e));
    }
  }

  void _emit(UiState<List<DigitalCard>> state) {
    _state = state;
    // Chips are hidden when there is nothing to filter: never keep a filter
    // the user cannot see.
    if (state is UiSuccess && !canFilter) _filter = CardFilter.all;
    _visible = switch (state) {
      UiSuccess(:final data) when _filter != CardFilter.all => UiSuccess(
        data.where(_filter.accepts).toList(),
      ),
      _ => state,
    };
    notifyListeners();
  }
}
