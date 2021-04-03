import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action_type.dart';
import 'package:test_actions/test_actions.dart';
import 'package:mockito/mockito.dart';

class WidgetTesterMock extends Mock implements WidgetTester {}

void main() async {
  WidgetTesterMock mockTester = WidgetTesterMock();
  late TestActions actions;

  setUp(() {
    actions = TestActions();
    actions.tester = mockTester;
    actions.resetActions();
  });

  group('TestAction test', () {
    test('out of bound action perform', () async {
      try {
        await actions.performActionAt(2);
      } catch (e) {
        expect(e, isInstanceOf<Exception>());
      }
    });

    test('perform all actions when list is empty', () async {
      dynamic result = await actions.performAllActions();
      expect(result, isNull);
    });

    test('adding one action and then reset', () {
      actions.addAction(TestAction(actionType: TestActionType.AwaitFuture));
      expect(actions.actions.length, 1);
      actions.resetActions();
      expect(actions.actions.length, 0);
      expect(actions.tester, isNotNull);
    });
    test('adding more actions', () {
      addSampleActions(actions);
      expect(actions.actions.length, 4);
    });
    test('running a single custom action', () async {
      addSampleActions(actions);
      await actions.performActionAt(1);
      expect(actions.isActionDone(1), true);
    });
    test('run all the actions', () async {
      addSampleActions(actions);
      await actions.performAllActions();
      for (int i = 0; i < actions.actions.length; i++) {
        expect(actions.isActionDone(i), true);
      }
    });
  });
}

void addSampleActions(TestActions actions, {bool addOne = false}) {
  if (addOne)
    actions.addAction(TestAction(
      actionType: TestActionType.CustomAction,
      executePumpAndSettle: false,
      customAction: () {
        print('This is my test custom action');
      },
    ));
  else
    actions.addMultipleActions([
      TestAction(
        actionType: TestActionType.AwaitFuture,
        executePumpAndSettle: false,
        awaitDuration: Duration(seconds: 2),
      ),
      TestAction(
        actionType: TestActionType.CustomAction,
        executePumpAndSettle: false,
        customAction: () {
          print('This is my test custom action');
        },
      ),
      TestAction(
        actionType: TestActionType.CustomAction,
        executePumpAndSettle: false,
        customAction: () {
          print('This is my second test for a custom action');
        },
      ),
      TestAction(
        actionType: TestActionType.AwaitFuture,
        executePumpAndSettle: false,
        awaitDuration: Duration(seconds: 2),
      ),
    ]);
}
