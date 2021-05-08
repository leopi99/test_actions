///Actions that can be performed on the [WidgetTester]
enum TestActionType {
  Press,
  EnterText,
  PumpAndSettle,
  FutureAwait,
  CustomAction,
  Pump,
  Drag,
}

extension valueOnActionType on TestActionType {
  String get toValue => this.toString().split('.').last;
}
