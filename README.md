# test_actions

This plugin can be used to facilitate the integration test on a Flutter app, handles the tests at a "higher" level.

## Getting Started
Add this line to the dev_dependencies in the pubspec.yaml file in your project.
```
test_actions: ^1.0.0
```

## Usage
If you have never used integration tests, please follow the [official guide](https://flutter.dev/docs/testing/integration-tests) to create the files necessary to use the integration tests.

Then you just have to import the package with:
```
import 'package:test_actions/test_actions.dart';
```
Since Flutter 2 the integration_test plugin is integrated into the sdk:
```
dev_dependencies:
  integration_test:
    sdk: flutter
```
The first things to set up is the TestActions itself; this is the class that contains all the actions that you will execute, this class needs a WidgetTester if you don't want to set it for all the actions that you add.
Of course the tester should be assigned inside the testWidgets method.
```
TestActions actions = TestActions();
actions.setTester(tester);
```
If you don't see the table below correctly, open the [GitHub](https://github.com/leopi99/test_actions) page.

Currently there are 5 actions that you can perform using this plugin:
Action name | Effect | Required vars
----------- | ------ | ---------
pump | Executes the pump command on the WidgetTester for a number of times defined by the {pumpTimes} variable. | If you set the awaitDuration it will be used as duration in the pump command.
pumpAndSettle | Executes the pumpAndSettle command on the WidgetTester.
press | Executes the tap on the WidgetTester using a Finder. | This action needs the finder not to be null
futureAwait | Awaits for a certain Duration. | This action needs the awaitDuration not to be null.
customAction | Executes a custom function. | This action needs the customAction function not to be null.
drag | Executes a drag action | This action needs the dragOffset not to be null.
enterText | Enters a text into a textfield or a widget that accepts text as input | This function needs enterText not to be null.

From version 1.0.0 you can assign a name to the testActions to find more easily the failed action.

You can perform all the actions in order
```
await actions.performActions();
```
Or perform only one action:
```
await actions.performActionAt(0);
```

The TestAction doesn't need to be inside the TestActions class, you can create an action and perform by itself
```
TestAction singleAction = TestAction(
  action: TestActionType.CustomAction, 
  customAction: () {
    print('This is a custom action');
    expect(1 + 1, 2);
  }
);
singleAction.performAction();
```

To perform the single TestAction, you can add the action index and/or the function to be called when the action is performed.
