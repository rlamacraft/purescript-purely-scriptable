LOCATION="$HOME/Library/Mobile\ Documents/iCloud~dk~simonbs~Scriptable/Documents/$1.js"
echo $LOCATION
pulp build -O --to output.js
printf '%b\n%s\n' "// Variables used by Scriptable.\n// These must be at the very top of the file. Do not edit.\n// icon-color: blue; icon-glyph: magic; share-sheet-inputs: plain-text;\nfunction setTimeout(f, _){f();}" "$(cat output.js)" > ~/Library/Mobile\ Documents/iCloud~dk~simonbs~Scriptable/Documents/$1.js
echo "Finished compiling to $LOCATION"