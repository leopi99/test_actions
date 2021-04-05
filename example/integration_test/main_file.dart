import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_actions/test_actions.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestActions actions;

  setUp(() {
    actions = TestActions();
  });

  testWidgets("Button press test", (WidgetTester tester) async {
    await tester.pumpWidget(app.MyApp());
    actions.tester = tester;
    actions.addMultipleActions([
      TestAction(actionType: TestActionType.PumpAndSettle),
      TestAction(
        actionType: TestActionType.Press,
        finder: find.byType(FloatingActionButton),
      ),
      TestAction(
        actionType: TestActionType.CustomAction,
        customAction: () {
          expect(find.text('1'), findsOneWidget);
        },
      ),
    ]);
    await actions.performAllActions();
  });
}
