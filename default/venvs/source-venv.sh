#!/bin/bash
set -e

SCRIPT_DIR__SOURCE_VENV=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
OS=$(uname | awk '{print tolower($0)}')
[[ "$OS" == "darwin" ]] && OS="macos"

if [[ -d "$SCRIPT_DIR__SOURCE_VENV/$OS" ]]; then
  bash "$SCRIPT_DIR__SOURCE_VENV"/update-venv.sh "$OS"
else
  echo "--> creating venv..." >&2
  bash "$SCRIPT_DIR__SOURCE_VENV"/create-venv.sh
fi

ACTIVATE_PATH="$SCRIPT_DIR__SOURCE_VENV/$OS/bin/activate"
echo "--> activating : $ACTIVATE_PATH" >&2
source "$ACTIVATE_PATH"

