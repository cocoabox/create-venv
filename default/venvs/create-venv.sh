#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

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
  PY_VER=$(cat "$SCRIPT_DIR"/../python-ver)
  if [[ -z "$PY_VER" ]]; then
    PY="python3"
    echo "using $PY ; to use another python version, e.g. 3.11, type : `tput bold`PY=python3.11 $0`tput sgr0` ; or type : `tput bold`cat 3.11 > ../python-ver`tput sgr0`" >&2
    sleeper 5
  else
    PY="python${PY_VER}"
    $PY --version
    if [[ $! -ne 0 ]]; then
        echo "$PY command not found ; using python3 instead ; python version requirement might not be met"
        sleeper 5
        PY=python3
    fi
  fi
fi


# check python ver
export PY
set -e
bash "$SCRIPT_DIR"/check-python-ver.sh

OS=$(uname | awk '{print tolower($0)}')
[[ "$OS" == "darwin" ]] && OS="macos"

if [[ -d "$SCRIPT_DIR/$OS" ]]; then
  echo "found existing venv dir" >&2
else
  echo "creating venv..." >&2
  TMP="$(mktemp -d)"
  pushd "$TMP" >/dev/null 2>&1
  $PY -m venv --copies "$OS"
  pushd "$OS" >/dev/null 2>&1
  source bin/activate
  echo "installing requirements..." >&2
  pip3 install -r "$SCRIPT_DIR"/../requirements.txt
  popd  >/dev/null
  echo "moving venv to $SCRIPT_DIR and updating permissions..." >&2
  mv "$OS" "$SCRIPT_DIR"
  popd  >/dev/null
  rm -R "$TMP"
  pushd "$SCRIPT_DIR"  >/dev/null
  chmod -R a+w,g+w "$OS"
  popd >/dev/null
fi

set -e
echo "updating path reference"
bash "$SCRIPT_DIR"/update-venv.sh "$OS"


echo "thanks" >&2
