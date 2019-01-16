#!/bin/env bash

newfile_generatorgenerate(){
local fil="${1}"

echo '#!/bin/bash
# This script is executed every time a theme is generated.
# Each generator can have it'"'"'s own _mondo-generate script.

# The default syntax is bash, but by changing the shebang,
# one could use another language (f.i. perl or python).

# $1 is equal to: $MONDO_DIR/generator/TYPE/THEME[.extensions]

# If this script is not needed, this file can safely be removed.
# (removing the file, will improve executioni speed)

# MONDO_DIR="${1%%/generator*}"
# THIS_DIR="${1%/*}"
# THIS_GENERATOR="${THIS_DIR##*/}"
# THIS_FILE="${1##*/}"
# THIS_THEME="${THIS_FILE%.*}"

# To source the settings file one could use this:
# source "${THIS_DIR}/_mondo-settings"
' > "$fil"
chmod +x "$fil"
}
