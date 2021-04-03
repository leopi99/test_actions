import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action_type.dart';
import 'package:test_actions/test_actions.dart';
import 'package:mockito/mockito.dart';

class WidgetTesterMock extends Mock implements WidgetTester {}

void main() async {
  WidgetTesterMock mockTester = WidgetTesterMock();
  TestActions actions = TestActions();

  actions.tester = mockTester;

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
      actions.addMultipleActions([
        TestAction(
          actionType: TestActionType.AwaitFuture,
          awaitDuration: Duration(seconds: 2),
        ),
        TestAction(
          actionType: TestActionType.CustomAction,
          customAction: () {
            print('This is my test custom action');
          },
        ),
        TestAction(
          actionType: TestActionType.CustomAction,
          customAction: () {
            print('This is my second test for a custom action');
          },
        ),
        TestAction(
          actionType: TestActionType.AwaitFuture,
          awaitDuration: Duration(seconds: 2),
        ),
      ]);
      expect(actions.actions.length, 4);
    });
    test('running a single custom action', () async {
      await actions.performActionAt(1);
      expect(actions.isActionDone(1), true);
    });
  });
}
