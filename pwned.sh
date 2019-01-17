#!/bin/bash
# MIT License - Copyright (c) 2019 Stuart Taylor - https://github.com/stuartraetaylor

defaultPwnedfile="pwned-passwords-sha1-ordered-by-hash-v4.txt"
defaultLookbin="bin/look"

dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

pwnedfile="${1:-$dir/$defaultPwnedfile}"
echo "Using pwned file: ${pwnedfile/$dir\//}"

if [ ! -f "$pwnedfile" ]; then
    echo "File not found"
    exit 2
fi

lookbin="${2:-$dir/$defaultLookbin}"
echo "Using look command: ${lookbin/$dir\//}"

if [ ! -f "$lookbin" ]; then
    echo "Command not found"
    exit 2
fi

echo -n "Password: "
read -s passwd
echo "$(echo "$passwd" | sed -r 's/./*/g')"

result=$($lookbin -bf $(echo -n "$passwd" | sha1sum | cut -d' ' -f1) "$pwnedfile")
e=$?

if [ $e -gt 1 ]; then
    exit $e
fi

echo -n "Pwned: "

if [ $e -eq 1 ]; then
    echo "not pwned."
    exit 1
fi

#echo "$(echo -n "$result" | cut -d':' -f2) times"
echo "pwned!"
echo "$result" | cut -d':' -f2

exit 0

