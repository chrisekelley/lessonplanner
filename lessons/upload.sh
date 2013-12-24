#!/bin/sh
IDATE=$(date +%Y:%m:%d)
CLASSDIRNAME="Class 1 Eng audio"
WEEKDIRNAME="Week 1"
CLASSDIR=$(echo $CLASSDIRNAME | sed -f urlencode.sed)
WEEKDIR=$(echo $WEEKDIRNAME | sed -f urlencode.sed)
ENCODEDPATH=$CLASSDIRH%20$WEEKDIR
echo $ENCODEDPATH
(cd "audio/Class 1 Eng audio/Week 1"
for filename in *; do
    file=$(echo $filename | sed -f /Users/chrisk/source/lessonplanner/lessons/urlencode.sed)
    filepath=$ENCODEDPATH%20$file
    rev="$(curl -X PUT http://localhost:5984/lessonplanner/$file -d '{"name":"'"$file"'", "date": "'"$IDATE"'" }' | sed -ne 's/^.*"rev":"\([^"]*\)".*$/\1/p')"
    echo "rev=$rev, filename = $filename, file = $file, filepath = $filepath"
    curl --data-binary  "@$filename"  -X PUT http://localhost:5984/lessonplanner/$file/contents?rev="$rev"
done)
