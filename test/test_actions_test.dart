import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action_type.dart';
import 'package:test_actions/test_actions.dart';
import 'package:mockito/mockito.dart';

class WidgetTesterMock extends Mock implements WidgetTester {}

void main() async {
  WidgetTesterMock mockTester;
  late TestActions actions;

  setUp(() {
    mockTester = WidgetTesterMock();
    actions = TestActions(tester: mockTester);
    actions.resetActions();
  });

  group('TestAction test', () {
    test('[out of bound action perform]', () async {
      try {
        await actions.performActionAt(2);
      } catch (e) {
        expect(e, isInstanceOf<Exception>());
      }
    });

    test('[perform all actions when list is empty]', () async {
      await actions.performActions();
      expect(actions.areAllDone(), true);
    });

    test('[adding one action and then reset]', () {
      actions.addAction(TestAction(action: TestActionType.FutureAwait));
      expect(actions.actions.length, 1);
      actions.resetActions();
      expect(actions.actions.length, 0);
      expect(actions.tester, isNotNull);
    });
    test('[adding more actions]', () {
      addSampleActions(actions);
      expect(actions.actions.length, 4);
    });
    test('[running a single custom action]', () async {
      addSampleActions(actions);
      await actions.performActionAt(1);
      expect(actions.isActionDone(1), true);
    });
    test('[run all the actions]', () async {
      addSampleActions(actions);
      await actions.performActions();
      for (int i = 0; i < actions.actions.length; i++) {
        expect(actions.isActionDone(i), true);
      }
    });
    test('[Perform a single action without TestActions]', () {
      TestAction action = TestAction(
        action: TestActionType.FutureAwait,
        awaitDuration: Duration(seconds: 2),
      );
      action.performAction();
    });
    test('[add one action at index 2]', () async {
      addSampleActions(actions);
      expect(actions.actions.length, 4);
      actions.addActionAt(
          2,
          TestAction(
            action: TestActionType.CustomAction,
            customAction: () {
              print('The custom action at index 2 is working');
            },
          ));
      expect(actions.actions.length, 5);
    });
    test('[Check the equality of 2 TestActions] should return false', () {
      TestAction action = TestAction(
          action: TestActionType.EnterText, actionName: 'testActionName');
      TestAction other = TestAction(
          action: TestActionType.EnterText,
          awaitDuration: Duration(seconds: 5));
      expect(action == other, false);
    });
    test('[Check the equality of 2 TestActions] should return true', () {
      TestAction action = TestAction(
        action: TestActionType.Drag,
        actionName: 'name',
        awaitDuration: Duration(seconds: 1),
        dragOffset: Offset(0, 2),
        enterText: 'text',
        executePumpAndSettle: false,
        pumpTime: 2,
      );
      TestAction other = TestAction(
        action: TestActionType.Drag,
        actionName: 'name',
        awaitDuration: Duration(seconds: 1),
        dragOffset: Offset(0, 2),
        enterText: 'text',
        executePumpAndSettle: false,
        pumpTime: 2,
      );
      expect(action == other, true);
    });
  });
}

void addSampleActions(TestActions actions, {bool addOne = false}) {
  if (addOne)
    actions.addAction(TestAction(
      action: TestActionType.CustomAction,
      executePumpAndSettle: false,
      customAction: () {
        print('This is my test custom action');
      },
    ));
  else
    actions.addActionsAll([
      TestAction(
        action: TestActionType.FutureAwait,
        actionName: '***I am waiting for 2 seconds***',
        executePumpAndSettle: false,
        awaitDuration: Duration(seconds: 2),
      ),
      TestAction(
        action: TestActionType.CustomAction,
        executePumpAndSettle: false,
        customAction: () {
          print('This is my test custom action');
        },
      ),
      TestAction(
        action: TestActionType.CustomAction,
        executePumpAndSettle: false,
        customAction: () {
          print('This is my second test for a custom action');
        },
      ),
      TestAction(
        action: TestActionType.FutureAwait,
        executePumpAndSettle: false,
        awaitDuration: Duration(seconds: 2),
      ),
    ]);
}
