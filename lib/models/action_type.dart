///Actions that can be performed on the [WidgetTester]
enum ActionType {
  press,
  enterText,
  pumpAndSettle,
  futureAwait,
  customAction,
  pump,
  drag,
}

extension ValueOnActionType on ActionType {
  String get toValue => toString().split('.').last;
}
