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

data Close = Close

instance showClose :: Show Close where
  show Close = "Close"

getCount :: Button Option -> Int
getCount (Button option) = split (optionToSplitPattern option) argsText # length

main :: Effect Unit
main = do
  launchAff_ $ showOptionAlert <#> getCount >>= showCountAlert where
    showOptionAlert = newAlert # setTitle "Count what?" >>> addAction (Button Characters) >>> addAction (Button Words) >>> addAction (Button Lines) >>> presentAlert
    showCountAlert count = newAlert # setTitle (show count) >>> addAction (Button Close) >>> presentAlert
```
