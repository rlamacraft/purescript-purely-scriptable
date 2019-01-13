# replace commit hash in bower.json
JQ_get=$(printf '.dependencies."purescript-purely-scriptable" | sub("#.*"; "#%s")' "$1")
NEW=$(cat bower.json | jq "$JQ_get")
JQ_set=$(printf '.dependencies."purescript-purely-scriptable" |= %s' "$NEW")
NEW_content=$(cat bower.json | jq "$JQ_set")
echo $NEW_content > bower.json

# update bower
bower update
