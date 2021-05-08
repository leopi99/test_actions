## [0.1.0] - 05/04/2021 (DD/MM/YYYY)

* First release of the plugin.

## [0.2.0] - 13/04/2021 (DD/MM/YYY)
* BREAKING CHANGE: Renamed performAllActions to performActions
* BREAKING CHANGE: Renamed AwaitFuture (TestActionType) to FutureAwait
* BREAKING CHANGE: performActions won't return Null type, instead
* Added Drag and EnterText action types.

## [0.2.1] - 08/05/2021 (DD/MM/YYY)
* Corrected typos in some messages.
* The pumpAndSettle can be done even if the action is EnterText.
* The parameters (Function setAsDone & int actionIndex) for the single action to perform are now optional.