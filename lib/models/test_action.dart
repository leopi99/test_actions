import 'package:flutter_test/flutter_test.dart';

enum TestActionType {
  Pump,
  PumpAndSettle,
  Press,
  AwaitFuture,
  CustomAction,
}

///Test action, class that can be performed on a [WidgetTester].
class TestAction {
  final TestActionType actionType;

  ///Type [Duration].
  ///
  ///Can be used as [Duration] for the pump.
  ///
  ///Throws an error if the [TestActionType] is AwaitFuture, but this is null.
  final Duration? awaitDuration;
  final int pumpTimes;
  final Finder? finder;
  final WidgetTester tester;

  TestAction({
    required this.actionType,
    this.awaitDuration,
    this.pumpTimes = 30,
    this.finder,
    required this.tester,
  });

  Future<dynamic> performAction(int actionIndex) async {
    final TestRestorationData restorationData =
        await tester.getRestorationData();
    try {
      switch (actionType) {
        case TestActionType.PumpAndSettle:
          await tester.pumpAndSettle();
          break;
        case TestActionType.Pump:
          bool pumpDone = false;
          for (int i = 0; i < pumpTimes; i++) {
            await tester.pump(awaitDuration);
            if (i == pumpTimes - 1) pumpDone = true;
          }
          while (!pumpDone) {
            await Future.delayed(awaitDuration ?? Duration(milliseconds: 100));
          }
          break;
        default:
      }
    } catch (e) {
      print(
          '* Error accoured while performing ${actionType.toString().split('.')[1]} action #$actionIndex');
      print('* ErrorType: ${e.runtimeType}\t Message: ${e.toString()}');
      print('* Restoring to the previous data: ${restorationData.toString()}');
      tester.restoreFrom(restorationData);
      return;
    }
  }

  TestAction copyWith({
    TestActionType? actionType,
    WidgetTester? tester,
    int? pumpTimes,
    Duration? awaitDuration,
    Finder? finder,
  }) =>
      TestAction(
        actionType: actionType ?? this.actionType,
        tester: tester ?? this.tester,
        pumpTimes: pumpTimes ?? this.pumpTimes,
        awaitDuration: awaitDuration ?? this.awaitDuration,
        finder: finder ?? this.finder,
      );
}
