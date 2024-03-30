#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <object>"
    exit 1
fi

object="$1"

if [[ "$object" == /* ]]; then
    path="$object"
else
    path="$(readlink -f "$object")"
fi

specs () {
    if [ -e $object ]; then 
    echo "Object name: $object"
    echo "Object type: $(stat -c '%F' "$object")"
    echo "Object size: $(stat -c '%s bytes' "$object")" 
    echo "Object ownership: $(stat -c '%U' "$object")"
    echo "Object permissions: $(stat -c %A $object)"
    echo "Last modified: $(date -r $object "+%m-%d-%Y %H:%M:%S")"

    else
        echo "No file by the name of $object was found in $PWD"
        exit 1 
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    specs "$path"
fi