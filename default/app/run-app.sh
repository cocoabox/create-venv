#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/../venvs/ensure-venv.sh

echo "==> running..." >&2

python3 "$SCRIPT_DIR"/example-app.py


