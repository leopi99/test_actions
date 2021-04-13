import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action.dart';

///Class to perform action during the integration tests

class TestActions {
  late List<TestAction> _actions;
  late List<bool> _doneActions;
  WidgetTester? _tester;

  List<TestAction> get actions => _actions;

  ///If the [WidgetTester] is set will be returned, otherwise will get null
  dynamic get tester => _tester;

  TestActions({List<TestAction>? actions, WidgetTester? tester}) {
    if (actions != null && actions.length > 0)
      actions.forEach((element) {
        addAction(element);
      });
    else
      _actions = [];
    _doneActions = [];
    if (tester != null) _tester = tester;
  }

  ///Sets the [WidgetTester] to the class, set this before adding the [List] of [TestAction].
  ///
  ///By adding this tester, you can avoid to add the tester to every [TestAction].
  void setTester(WidgetTester tester) => _tester = tester;

  ///Performs all actions in order.
  ///
  ///failsAt [Duration] tells the test to fail after this much time
  ///
  ///Defaults to 5 minutes
  Future<void> performActions(
      {Duration failsAt = const Duration(minutes: 5)}) async {
    Timer.periodic(failsAt, (timer) {
      throw Exception('Test not completed after 5 minutes');
    });
    for (int i = 0; i < _actions.length; i++) {
      if (!_doneActions[i]) await performActionAt(i);
    }
    while (!_doneActions.every((element) => element)) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    return;
  }

  ///Performs a single action.
  Future<void> performActionAt(int index) async {
    if (index > _actions.length)
      throw Exception(
          'Out of bound exception, the selected index [$index] is greater then the list [${_actions.length}]');
    if (!_doneActions[index]) {
      await _actions[index]
          .performAction(setAsDone: _setActionAsDone, actionIndex: index);
      do {
        await Future.delayed(Duration(milliseconds: 100));
      } while (!_doneActions[index]);
    }
  }

  ///Adds an action at the end of the others.
  ///
  /// If the [WidgetTester] has been set, will be used instead of the one in the [TestAction]
  void addAction(TestAction action) {
    _actions.add(_tester != null ? action.copyWith(tester: _tester) : action);
    _doneActions.add(false);
  }

  ///Adds a [List] of [TestAction]
  void addActionsAll(List<TestAction> multipleActions) {
    multipleActions.forEach((element) {
      addAction(element);
    });
    print('* Added ${_actions.length} actions');
  }

  ///Adds a [TestAction] at [int] index
  void addActionAt(int index, TestAction action) {
    _actions.insert(
        index, _tester != null ? action.copyWith(tester: _tester) : action);
    print('* Added a new action at index $index');
  }

  void _setActionAsDone(int index) => _doneActions[index] = true;

  ///Resets the actions and the [WidgetTester]
  void resetActions() {
    print('** Actions reset **');
    _actions = [];
    _doneActions = [];
  }

  ///Returns true if an action is done
  bool isActionDone(int index) => _doneActions[index];

  ///Returns true if all actions are done
  bool areAllDone() => _doneActions.every((element) => element);
}
