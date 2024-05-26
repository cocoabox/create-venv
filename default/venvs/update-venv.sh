#!/bin/bash
VENV_NAME="$1"
[[ -z "$VENV_NAME" ]] && echo "usage : $0 [VENV_NAME]" >&2 && exit 1

# Get script directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
VENV_DIR="$SCRIPT_DIR/$VENV_NAME"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "missing venv dir : $VENV_DIR ; please run first : create-venv.sh" >&2
  exit 1
fi

# Extract venv directory from pyvenv.cfg
LOADED_VENV_DIR=$(awk -F " = " '/^command/ {sub(/.* /,"",$2); print $NF}' "$SCRIPT_DIR/pyvenv.cfg" 2>/dev/null )

if [[ -z "$LOADED_VENV_DIR" ]]; then
  echo "--> inspecting shebang of $VENV_DIR/bin/pip" >&2
  LOADED_VENV_DIR=$( head -n1 "$VENV_DIR"/bin/pip | sed -E 's|^#!(.*)/bin/python([^ ]+).*|\1|' )
fi


if [ "$VENV_DIR" != "$LOADED_VENV_DIR" ]; then
    set -e
    echo "--> updating venv dir reference : $LOADED_VENV_DIR ---> $VENV_DIR" >&2
    # Update activate script
    sed -i  "s|$LOADED_VENV_DIR|$VENV_DIR|g" "$VENV_DIR/pyvenv.cfg"
    sed -i  "s|$LOADED_VENV_DIR|$VENV_DIR|g" "$VENV_DIR/bin/activate"

    # Update shebang lines
    for FILE in "$VENV_DIR/bin"/*; do
        if head -n 1 "$FILE" | grep -q "^#!"; then
            sed -i  "1s|$LOADED_VENV_DIR/bin/python|$VENV_DIR/bin/python|g" "$FILE"
        fi
    done
else
    echo "    dir reference to '$VENV_DIR' looks good" >&2
fi
