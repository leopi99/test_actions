import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/action_type.dart';

///Class to perform a certain [ActionType] on the [WidgetTester]
class TestAction {
  ///Type of the action to be performed on the [Finder] widget.
  final ActionType actionType;

  ///Only needed if the tester is not set in the [TestActions] class or is executed outside the cited class.
  ///
  ///Fails the test if this condition is not satisfied.
  final WidgetTester? tester;

  ///Needed when [ActionType] != PumpAndSettle.
  ///
  ///Fails the test if this condition is not satisfied.
  final Finder? finder;

  ///Needed when [ActionType] == EnterText.
  ///
  ///Fails the test if this condition is not satisfied.
  final String? enterText;

  ///Needed when [ActionType] == AwaitFuture
  ///
  ///Can be used as the [Duration] of the Pump Action
  ///
  ///Fails the test if this condition is not satisfied.
  final Duration? awaitDuration;

  ///Needed when [ActionType] == CustomAction
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
  /// Needed when the [ActionType] == Drag
  final Offset? dragOffset;

  /// The name of this action
  final String? actionName;

  TestAction({
    required this.actionType,
    this.tester,
    this.finder,
    this.enterText,
    this.awaitDuration,
    this.customAction,
    this.executePumpAndSettle = true,
    this.pumpTime = 5,
    this.dragOffset,
    this.actionName,
  });

  ///Performs the action
  Future<void> performAction(
      {Function(int)? setAsDone, int actionIndex = 0}) async {
    debugPrint('Performing ${actionType.toValue} action $actionIndex');
    try {
      switch (actionType) {
        case ActionType.press:
          await tester!.tap(finder!);
          break;
        case ActionType.enterText:
          await tester!.enterText(finder!, enterText!);
          break;
        case ActionType.pumpAndSettle:
          await tester!.pumpAndSettle();
          break;
        case ActionType.futureAwait:
          await _executeFutureAwait();
          break;
        case ActionType.customAction:
          await customAction!();
          break;
        case ActionType.pump:
          await _executePump(setAsDone, actionIndex);
          return;
        case ActionType.drag:
          await tester!.drag(finder!, dragOffset!);
          break;
      }
      if (executePumpAndSettle) {
        debugPrint('Executing pumpAndSettle');
        await tester!.pumpAndSettle(const Duration(milliseconds: 500));
      } else {
        debugPrint('* Avoiding the pumpAndSettle');
      }
    } catch (e, stacktrace) {
      _printError(e, actionIndex, surplusMessage: '\n$stacktrace');
      return;
    }
    if (setAsDone != null) setAsDone(actionIndex);
    debugPrint('Action ${actionType.toValue} #$actionIndex done');
    return;
  }

  void _printError(dynamic e, int actionIndex, {String? surplusMessage}) {
    String firstMessage =
        '* Error occurred while performing ${actionType.toValue} action: ${actionName ?? '#' + actionIndex.toString()}';
    String secondMessage =
        '* ErrorType: ${e.runtimeType}\t Message: ${e.toString()}';
    String divider = ''.padLeft(firstMessage.length + 1, "=");
    debugPrint(divider);
    debugPrint(firstMessage);
    debugPrint(secondMessage);
    if (surplusMessage != null) debugPrint('* $surplusMessage');
    debugPrint(divider);
  }

  TestAction copyWith({
    ActionType? actionType,
    WidgetTester? tester,
    Finder? finder,
    String? enterText,
    Duration? awaitDuration,
    Function? customAction,
    bool? executePumpAndSettle,
    Offset? dragOffset,
    int? pumpTime,
    String? actionName,
  }) =>
      TestAction(
        actionType: actionType ?? this.actionType,
        executePumpAndSettle: executePumpAndSettle ?? this.executePumpAndSettle,
        awaitDuration: awaitDuration ?? this.awaitDuration,
        finder: finder ?? this.finder,
        enterText: enterText ?? this.enterText,
        tester: tester ?? this.tester,
        customAction: customAction ?? this.customAction,
        dragOffset: dragOffset ?? this.dragOffset,
        pumpTime: pumpTime ?? this.pumpTime,
        actionName: actionName ?? this.actionName,
      );

  @override
  bool operator ==(Object other) {
    List<String> differences = [];
    if (runtimeType != other.runtimeType) differences.add('runTime Type');
    if (other is! TestAction) return false;
    if (actionType != other.actionType) differences.add('ActionType');
    if (pumpTime != other.pumpTime) differences.add('pumpTime');
    if (enterText != other.enterText) differences.add('enterText');
    if (awaitDuration != other.awaitDuration) differences.add('awaitDuration');
    if (executePumpAndSettle != other.executePumpAndSettle) {
      differences.add('executePumpAndSettle');
    }
    if (dragOffset != other.dragOffset) differences.add('dragOffset');
    if (actionName != other.actionName) differences.add('actionName');
    if (differences.isNotEmpty) debugPrint('Differences: $differences');
    return differences.isEmpty;
  }

  @override
  int get hashCode => actionType.toValue.hashCode;

  ///Executes the pump
  Future<void> _executePump(Function(int)? setAsDone, int? actionIndex) async {
    debugPrint('* Pumping for $pumpTime times');
    bool pumpDone = false;
    for (int i = 0; i < pumpTime; i++) {
      await tester!.pump(const Duration(milliseconds: 100));
      if (i == pumpTime - 1) pumpDone = true;
    }
    do {
      await Future.delayed(const Duration(milliseconds: 100));
    } while (!pumpDone);
    if (setAsDone != null) setAsDone(actionIndex ?? 0);
    debugPrint('Action ${actionType.toValue} #$actionIndex done');
  }

  ///Executes the await on the future
  Future<void> _executeFutureAwait() async {
    debugPrint(
        '** Future delayed by ${awaitDuration!.inSeconds}s -> ${awaitDuration!.inMilliseconds}ms');
    await Future.delayed(awaitDuration!);
  }
}
