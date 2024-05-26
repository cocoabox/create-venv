#!/bin/bash
SCRIPT_DIR__ENSURE_VENV=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VENVS_DIR=$(dirname "$SCRIPT_DIR__ENSURE_VENV")/venvs
PYTHON3_PATH=`which python3`
if [[ "$PYTHON3_PATH" == "$VENVS_DIR"* ]]; then
    :
else 
    source "$VENVS_DIR"/source-venv.sh
    PYTHON3_PATH=`which python3`
fi
echo "==> python3 is : $PYTHON3_PATH" >&2

