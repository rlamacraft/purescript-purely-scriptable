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
main = launchAff_ $ do
  Result (Button option) _ <- showOptionAlert
  ArgsText text <- askIfNothing "No text passed from share sheet. Paste here instead." $ head argsText
  let pattern = optionToSplitPattern option
  split pattern text # length >>> show >>> displayString
```
