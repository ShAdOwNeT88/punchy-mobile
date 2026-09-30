import 'package:flutter/foundation.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/shared/ui/ui_state.dart';

class CardDetailViewModel extends ChangeNotifier {
  CardDetailViewModel(this._repository, this.cardId);

  final CardsRepository _repository;
  final String cardId;

  UiState<DigitalCard> _state = const UiLoading();
  UiState<DigitalCard> get state => _state;

  bool _showBack = false;

  /// Whether the card is turned to show its stamps.
  bool get showBack => _showBack;

  Future<void> load() async {
    if (_state is! UiLoading) {
      _state = const UiLoading();
      notifyListeners();
    }
    try {
      _state = UiSuccess(await _repository.getCard(cardId));
    } on Object catch (e) {
      _state = UiError(e);
    }
    notifyListeners();
  }

  void flip() => setShowBack(!_showBack);

  void setShowBack(bool value) {
    if (value == _showBack) return;
    _showBack = value;
    notifyListeners();
  }
}
