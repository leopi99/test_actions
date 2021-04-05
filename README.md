# test_actions

This plugin can be used to facilitate the integration test on a Flutter app, helps newbie to run integration tests.

## Getting Started
Add this line to the dev_dependencies in the pubspec.yaml file in your project.
```
test_actions:
```

## Usage
If you have never used integration tests, please follow the [official guide](https://flutter.dev/docs/testing/integration-tests) to create the files necessary to use the integration tests.

Then you just have to import the package with:
```
import 'package:test_actions/test_actions.dart';
```

The first things to set up is the TestActions itself; this is the class that contains all the actions that you will execute, this class needs a WidgetTester if you don't want to set it for all the actions that you add.
Of course the tester should be assigned inside the testWidgets method.
```
TestActions actions = TestActions();
actions.tester = tester;
```
Currently there are 5 actions that you can perform using this plugin:
Action name | Effect | Constants
------------| ------ | -----------
Pump | Executes the pump command on the WidgetTester for a number of times defined by the {pumpTimes} variable(default to 30). | If you set the awaitDuration it will be used as duration in the pump command.
PumpAndSettle | Executes the pumpAndSettle command on the WidgetTester.
Press | Executes the tap on the WidgetTester using a Finder. | This action needs the finder not to be null
AwaitFuture | Awaits for a certain Duration. | This action needs the awaitDuration not to be null.
CustomAction | Executes a custom function. | This action needs the customAction function not to be null.

You can perform all the actions in order
```
await actions.performAllActions();
```
Or peforming only one action:
```
await actions.performActionAt(0);
```

The TestActions doesn't need to be inside the TestActions class, you can create an action and perform by itself
```
TestAction singleAction = TestAction(
  actionType: TestActionType.CustomAction, 
  customAction: () {
    print('This is a custom action);
    expect(1 + 1, 2);
  }
);
singleAction.performAction(0, () {});
```

To perform, the single TestAction, needs two arguments, the index of the action and a function that will be called when the action is completed.
