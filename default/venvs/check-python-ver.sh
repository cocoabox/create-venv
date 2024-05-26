#!/bin/bash
set -e
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

if [[ -z "$SCRIPT_DIR"/../python-ver ]]; then
  echo "../python-ver not found ; please write a python version , e.g. '3.11' into this file" >&2
  exit 0
fi
minimum_version=$(cat "$SCRIPT_DIR"/../python-ver )

sleeper() {
    local duration=$1
    while [ $duration -gt 0 ]; do
        echo -ne "\r(...continuing in $duration sec)"
        sleep 1
        duration=$((duration - 1))
    done
    echo -en "\r\033[K"  # Clear the line
}

if [[ -z "$PY" ]]; then
  PY="python3"
  echo "using $PY ; to use another python version, e.g. 3.11, type : PY=python3.11 $0" >&2
  sleeper 5
fi

installed_version=$("$PY" --version 2>&1 | cut -d' ' -f2)
version_compare() {
    test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$1"
}

if version_compare "$minimum_version" "$installed_version"; then
    echo "ok! got $installed_version " >&2
    echo "$PY"
    exit 0
else
    echo "need python $minimum_version ; got $installed_version" >&2
    exit 1
fi
