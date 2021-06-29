///Actions that can be performed on the [WidgetTester]
enum ActionType {
  Press,
  EnterText,
  PumpAndSettle,
  FutureAwait,
  CustomAction,
  Pump,
  Drag,
}

extension valueOnActionType on ActionType {
  String get toValue => this.toString().split('.').last;
}
