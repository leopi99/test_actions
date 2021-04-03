import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action.dart';
import 'package:test_actions/test_actions.dart';

class TestActions {
  WidgetTester? _tester;

  WidgetTester get tester => _tester!;
  set tester(WidgetTester tester) => _tester = tester;

  late List<TestAction> _actions;
  List<TestAction> get actions => _actions;

  late List<bool> _doneActions;

  TestActions({List<TestAction>? actions}) {
    if (actions != null && actions.isEmpty) {
      addMultipleActions(actions);
    } else {
      _actions = [];
      _doneActions = [];
    }
  }

  Future<dynamic> performAllActions() async {
    for (int i = 0; i < _actions.length; i++) {
      await _actions[i].performAction(i);
      do {
        await Future.delayed(
            _actions[i].awaitDuration ?? Duration(milliseconds: 50));
      } while (!_doneActions[i]);
      if (i == (_actions.length - 1) && _doneActions[i]) return true;
    }
  }

  Future<dynamic> performActionAt(int index) async {
    if (_actions.isNotEmpty && (_actions.length - 1) <= index) {
      return await _actions[index].performAction(index);
    } else
      throw Exception(
          "The action list is empty or the selected index is higer than the actions stored.");
  }

  void addAction(TestAction action) {
    _actions.add(_tester != null ? action.copyWith(tester: _tester) : action);
    _doneActions.add(false);
  }

  void addMultipleActions(List<TestAction> actions) {
    for (TestAction x in actions) {
      addAction(x);
    }
  }

  void resetActions({bool resetTester = false}) {
    _actions = [];
    _doneActions = [];
    if (resetTester) _tester = null;
  }
}
