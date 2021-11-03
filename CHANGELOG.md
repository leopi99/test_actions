## [2.0.0]
* BREAKING CHANGE: Renamed all the actions (Ex: Pump -> pump)
* BREAKING CHANGE: Renamed paramenter awaitFuture -> awaitDuration into TestAction.copyWith

## [1.0.0]
* BREAKING CHANGE: TestActionType => ActionType
* BREAKING CHANGE: TestAction.action => TestAction.actionType
* Can set a name to the actions.
* Override of the == operator

## [0.3.0]
* Executes all the actions recursively.

## [0.2.1]
* Corrected typos in some messages.
* The pumpAndSettle can be done even if the action is EnterText.
* The parameters (Function setAsDone & int actionIndex) for the single action to perform are now optional.

## [0.2.0]
* BREAKING CHANGE: Renamed performAllActions to performActions
* BREAKING CHANGE: Renamed AwaitFuture (TestActionType) to FutureAwait
* BREAKING CHANGE: performActions won't return Null type, instead
* Added Drag and EnterText action types.

## [0.1.0] - 05/04/2021 (DD/MM/YYYY)
* First release of the plugin.