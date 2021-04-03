import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_actions/models/test_action_type.dart';

///Test action, class that can be performed on a [WidgetTester].
class TestAction {
  final TestActionType actionType;

  ///Type [Duration].
  ///
  ///Can be used as [Duration] for the pump.
  ///
  ///Throws an error if the [TestActionType] is AwaitFuture, but this is null.
  final Duration? awaitDuration;

  ///Type [int]
  ///
  ///How many times the pump should be called
  ///
  ///The default value is 30
  final int pumpTimes;

  ///The finder used to find the widget to be pressed
  final Finder? finder;

  ///Custom function to be called
  final Function? customAction;

  ///The [WidgetTester] to performs the actions on.
  ///
  ///Should never be null
  late WidgetTester? tester;

  ///Decides if the pumpAndSettle should be run at the end of the action.
  ///
  ///The default value is true.
  final bool executePumpAndSettle;

  TestAction({
    required this.actionType,
    this.awaitDuration,
    this.pumpTimes = 30,
    this.finder,
    this.tester,
    this.customAction,
    this.executePumpAndSettle = true,
  });

  FutureOr<dynamic> performAction(
      int actionIndex, Function setActionAsDone) async {
    try {
      switch (actionType) {
        case TestActionType.PumpAndSettle:
          await tester!.pumpAndSettle();
          break;
        case TestActionType.Pump:
          bool pumpDone = false;
          for (int i = 0; i < pumpTimes; i++) {
            await tester!.pump(awaitDuration);
            if (i == pumpTimes - 1) pumpDone = true;
          }
          while (!pumpDone) {
            await Future.delayed(awaitDuration ?? Duration(milliseconds: 100));
          }
          break;
        case TestActionType.CustomAction:
          await customAction!();
          break;
        case TestActionType.Press:
          await tester!.tap(finder!);
          break;
        default:
          throw Exception('This action has not been yet implemented');
      }
    } catch (e) {
      String firstMessage =
          '* Error accoured while performing ${actionType.toString().split('.')[1]} action #$actionIndex';
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
      print(divider);
      return;
    }
    if (executePumpAndSettle) await tester!.pumpAndSettle();
    setActionAsDone(actionIndex);
  }

  TestAction copyWith({
    TestActionType? actionType,
    WidgetTester? tester,
    int? pumpTimes,
    Duration? awaitDuration,
    Finder? finder,
    Function? customAction,
  }) =>
      TestAction(
        actionType: actionType ?? this.actionType,
        tester: tester ?? this.tester,
        pumpTimes: pumpTimes ?? this.pumpTimes,
        awaitDuration: awaitDuration ?? this.awaitDuration,
        finder: finder ?? this.finder,
        customAction: customAction ?? this.customAction,
      );
}
