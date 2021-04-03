import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_actions/test_actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late TestActions actions;
  setUp(() {
    actions = TestActions();
  });

  testWidgets("", (WidgetTester tester) async {
    actions.tester = tester;
    actions.addMultipleActions([
      TestAction(
        actionType: TestActionType.PumpAndSettle,
      ),
      TestAction(
        actionType: TestActionType.Press,
        finder: find.text('+'),
      ),
    ]);
    await actions.performAllActions();

    expect(find.widgetWithText(Text, '1'), findsOneWidget);
    
    actions.resetActions();
    actions.addAction(
      TestAction(
        actionType: TestActionType.Press,
        finder: find.text('+'),
      ),
    );
    await actions.performActionAt(0);
    expect(find.widgetWithText(Text, '2'), findsOneWidget);
  });
}
