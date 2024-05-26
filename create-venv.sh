#!/bin/bash
TEMP_DIR=$(mktemp -d)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

if [[ -z "$1" ]]; then
    read -p "directory to create [`tput setaf 1`Return=`tput bold`quit`tput sgr0`] : " DIR
    [[ -z "$DIR" ]] && exit 1
else 
    DIR="$1"
fi

read -p "python version [`tput setaf 10`Return=`tput bold`3.12`tput sgr0`] : " PYTHON_VER
[[ -z "$PYTHON_VER" ]] && PYTHON_VER=3.12

echo -e "# requirements (e.g. mylib==1.2.3)" >  "$TEMP_DIR/requirements.txt"
while [[ true ]]; do
    EDITOR=vim
    pico -h >/dev/null 2>/dev/null
    [[ $? -eq 1 ]] && EDITOR=pico
    $EDITOR "$TEMP_DIR/requirements.txt" 
    echo -e "---\n`tput setaf 11`$(cat "$TEMP_DIR/requirements.txt")\n`tput sgr0`---"
    read -p "use the above requirements.txt [`tput setaf 10`y/Return=`tput bold`OK`tput sgr0`, else=edit again] : " CHOICE
    [[ -z "$CHOICE" ]] && CHOICE=y
    [[ "$CHOICE" == "y" ]] && break
done

echo "--> creating venv `tput bold`$DIR`tput sgr0`"
mkdir -p "$DIR"
rsync -vah8 "$SCRIPT_DIR/default/" "$DIR"
cp -v "$TEMP_DIR/requirements.txt" "$DIR/requirements.txt"
echo "$PYTHON_VER" > "$DIR/python-ver"

pushd "$DIR"/venvs >/dev/null
./create-venv.sh
popd >/dev/null

rm -Rf "$TEMP_DIR"

