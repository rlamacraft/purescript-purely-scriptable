# purescript-purely-scriptable
PureScript library for interfacing with the APIs exposed by the [Scriptable iOS app](https://scriptable.app).

## Example

This example script takes textual action extension input and counts either the Characters, the Words, or the number of Lines in the supplied text.

```purescript
data Option = Characters | Words | Lines

instance showOption :: Show Option where
  show Characters = "Characters"
  show Words      = "Words"
  show Lines      = "Lines"

optionToSplitPattern :: Option -> Pattern
optionToSplitPattern Characters = Pattern ""
optionToSplitPattern Words      = Pattern " "
optionToSplitPattern Lines      = Pattern "\n"

showOptionAlert :: Aff (AlertResult Option)
showOptionAlert = newAlert # setTitle "Count what?"
                    >>> addActions ((Button Lines):(Button Words):(Button Characters):Nil)
                    >>> presentAlert

main :: Effect Unit
main = run $ do
  Result (Button option) _ <- showOptionAlert
  ArgsText text <- askIfNothing "No text passed from share sheet. Paste here instead." $ head argsText
  let pattern = optionToSplitPattern option
  split pattern text # length >>> show >>> displayString
```

## Getting Started & Hello World

1.  Checkout this repo in some directory, REPO, and then navigate to the desired project directory.
2.  Create a PureScript project with `pulp init`.
3.  Install purescript-purely-scriptable
    1.  Add the following as a dependency in bower.json
        ```
        "purescript-purely-scriptable": "git://github.com/rlamacraft/purescript-purely-scriptable#v0.1.2"
        ```
    2.  Run `bower update` and `pulp build` to make sure everything works
4.  Write the Hello World program to src/Main.purs
    ```purescript
    module Main where

    import Prelude
    import Effect (Effect)

    import PurelyScriptable (run)
    import PurelyScriptable.Alert (displayString)

    main :: Effect Unit
    main = run $ do
      displayString "Hello, World!"
    ```
5.  Compile
    1.  First run `pulp build` to check for anything obvious
    2.  When happy, build and deploy to iOS with the following
        ```bash
        . $REPO/scripts/build.sh helloWorld
        ```
        This will copy the compiled JavaScript file to `~/Library/Mobile\ Documents/iCloud~dk~simonbs~Scriptable/Documents/`, the default location of the Scriptable iCloud directory.
6.  Execute
    Wait for iCloud to sync, and then execute from the Scriptable iOS app.
