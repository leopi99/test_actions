import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_actions/test_actions.dart';

import '../lib/main.dart' as app;

//To run this integration test run the following command:
// flutter driver --driver=test_driver/integration_test.dart --target=integration_test/main_file.dart
//With this command you can add the --flavor flag

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestActions actions;

  setUp(() {
    actions = TestActions();
  });

  testWidgets("Button press test", (WidgetTester tester) async {
    await tester.pumpWidget(app.MyApp());
    actions.setTester(tester);
    actions.addActionsAll([
      TestAction(
          actionType: ActionType.pumpAndSettle,
          actionName: '-> Wait for the app to start'),
      TestAction(
        actionType: ActionType.press,
        finder: find.byType(FloatingActionButton),
        actionName: '-> Pressing the FAB',
      ),
      TestAction(
        actionType: ActionType.customAction,
        actionName: '-> Expecting 1',
        customAction: () {
          expect(find.text('1'), findsOneWidget);
        },
      ),
      TestAction(
        actionType: ActionType.press,
        actionName: '-> Pressing the FAB',
        finder: find.byType(FloatingActionButton),
      ),
      TestAction(
        actionType: ActionType.customAction,
        actionName: '-> Expecting 2',
        customAction: () {
          expect(find.text('2'), findsOneWidget);
        },
      ),
    ]);
    await actions.performActions();
  });
}
