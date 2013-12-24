#!/bin/ksh

STR1=$(echo "https://www.xxxxxx.com/change&$ ^this to?%checkthe@-functionality" | cut -d\? -f1)
STR2=$(echo "https://www.xxxxxx.com/change&$ ^this to?%checkthe@-functionality" | cut -d\? -f2)

OUT2=$(echo "$STR2" | sed -f urlencode.sed)

echo "$STR1?$OUT2"
