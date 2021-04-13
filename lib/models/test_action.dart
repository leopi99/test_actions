import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action_type.dart';

///Class to perform a certain [ActionType] on the [WidgetTester]
class TestAction {
  ///Type of the action to be performed on the [Finder] widget.
  final TestActionType action;

  ///Only needed if the tester is not set in the [TestActions] class or is executed outside the cited class.
  ///
  ///Fails the test if this condition is not satisfied.
  final WidgetTester? tester;

  ///Needed when [TestActionType] != PumpAndSettle.
  ///
  ///Fails the test if this condition is not satisfied.
  final Finder? finder;

  ///Needed when [TestActionType] == EnterText.
  ///
  ///Fails the test if this condition is not satisfied.
  final String? enterText;

  ///Needed when [TestActionType] == AwaitFuture
  ///
  ///Can be used as the [Duration] of the Pump Action
  ///
  ///Fails the test if this condition is not satisfied.
  final Duration? awaitDuration;

  ///Needed when [TestActionType] == CustomAction
  ///
  ///Fails the test if this condition is not satisfied.
  final Function? customAction;

  ///Defaults to true, controls the execution of the [WidgetTester].pumpAndSettle at the end of the action.
  final bool executePumpAndSettle;

  ///How many times the pump should be called.
  ///
  /// Default to 5
  final int pumpTime;

  /// The [Offset] used to drag a [Widget] using the [Finder]
  ///
  /// Needed when the [TestActionType] == Drag
  final Offset? dragOffset;

  TestAction({
    required this.action,
    this.tester,
    this.finder,
    this.enterText,
    this.awaitDuration,
    this.customAction,
    this.executePumpAndSettle = true,
    this.pumpTime = 5,
    this.dragOffset,
  });

  // : assert(
  //     action == ActionType.EnterText
  //         ? enterText != null
  //         : enterText == null &&
  //                 ActionType.values.contains(action) &&
  //                 action == ActionType.PumpAndSettle
  //             ? finder == null
  //             : finder != null && action == ActionType.TestExpect
  //                 ? neededValue != null && valueToCheck != null
  //                 : neededValue == null &&
  //                         valueToCheck == null &&
  //                         action == ActionType.FutureAwait
  //                     ? awaitDuration != null
  //                     : awaitDuration == null &&
  //                             action == ActionType.CustomAction
  //                         ? customAction != null
  //                         : customAction == null,
  //   );

  ///Performs the action
  Future<void> performAction(
      {required Function setAsDone, required int actionIndex}) async {
    print('Performing ${action.toString().split('.')[1]} action #$actionIndex');
    try {
      switch (action) {
        case TestActionType.Press:
          await tester!.tap(finder!);
          break;
        case TestActionType.EnterText:
          await tester!.enterText(finder!, enterText!);
          break;
        case TestActionType.PumpAndSettle:
          await tester!.pumpAndSettle();
          break;
        case TestActionType.FutureAwait:
          print(
              '** Future delayed by ${awaitDuration!.inSeconds}s -> ${awaitDuration!.inMilliseconds}ms');
          await Future.delayed(awaitDuration!);
          break;
        case TestActionType.CustomAction:
          await customAction!();
          break;
        case TestActionType.Pump:
          print('* Pumping for $pumpTime times');
          bool pumpDone = false;
          for (int i = 0; i < pumpTime; i++) {
            await tester!.pump(Duration(milliseconds: 100));
            if (i == pumpTime - 1) pumpDone = true;
          }
          do {
            await Future.delayed(Duration(milliseconds: 100));
          } while (!pumpDone);
          setAsDone(actionIndex);
          print('Action ${action.toString().split('.')[1]} #$actionIndex done');
          return;
        case TestActionType.Drag:
          await tester!.drag(finder!, dragOffset!);
          break;
      }
      if (executePumpAndSettle && action != TestActionType.EnterText) {
        print('Executing pumpAndSettle');
        await tester!.pumpAndSettle(Duration(milliseconds: 500));
      } else
        print('* Avoiding the pumpAndSettle');
    } catch (e) {
      printError(e, actionIndex);
      return;
    }
    setAsDone(actionIndex);
    print('Action ${action.toString().split('.')[1]} #$actionIndex done');
    return;
  }

  void printError(dynamic e, int actionIndex, {String surplusMessage = ''}) {
    String firstMessage =
        '* Error accoured while performing ${action.toString().split('.')[1]} action #$actionIndex';
    String secondMessage =
        '* ErrorType: ${e.runtimeType}\t Message: ${e.toString()}';
    String divider = '';
    int higerLength = firstMessage.length > secondMessage.length
        ? firstMessage.length
        : secondMessage.length;
    for (int i = 0; i < higerLength + 1; i++) {
      divider += '=';
    }
    print(divider);
    print(firstMessage);
    print(secondMessage);
    if (surplusMessage != '') print('* $surplusMessage');
    print(divider);
  }

  TestAction copyWith({
    TestActionType? actionType,
    WidgetTester? tester,
    Finder? finder,
    String? enterText,
    Duration? awaitFuture,
    Function? customAction,
    bool? executePumpAndSettle,
    Offset? dragOffset,
    int? pumpTime,
  }) =>
      TestAction(
        action: actionType ?? this.action,
        executePumpAndSettle: executePumpAndSettle ?? this.executePumpAndSettle,
        awaitDuration: awaitDuration ?? this.awaitDuration,
        finder: finder ?? this.finder,
        enterText: enterText ?? this.enterText,
        tester: tester ?? this.tester,
        customAction: customAction ?? this.customAction,
        dragOffset: dragOffset ?? this.dragOffset,
        pumpTime: pumpTime ?? this.pumpTime,
      );
}
