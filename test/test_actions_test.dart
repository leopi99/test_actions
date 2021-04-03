import 'package:flutter_test/flutter_test.dart';
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
  });
}
