#! /usr/bin/env bash
#
# Parse class JS file and generate UML class block
# Usage: ./js-uml-block.sh <path-to-js-file>

# Check if a file path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path-to-js-file>"
  exit 1
fi

# Read the file
JS_FILE="$1"

# Check if the file exists
if [ ! -f "$JS_FILE" ]; then
  echo "Error: File not found!"
  exit 1
fi

# Extract the class name
CLASS_NAME=$(grep -Eo 'class [A-Za-z_][A-Za-z0-9_]*' "$JS_FILE" | awk '{print $2}')

# Extract properties (assumes properties are defined in the constructor with `this.`)
PROPERTIES=$(grep -Eo 'this\.[A-Za-z_][A-Za-z0-9_]*' "$JS_FILE" | sed 's/this\.//' | sort -u | sed 's/^/ /')

# Extract methods (assumes methods are defined as `methodName() {`)
METHODS=$(grep -Eo '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(' "$JS_FILE" | sed 's/[[:space:]]*//;s/($/()/' | sort -u | sed 's/^/ /')

# Calculate the width of the UML block
MAX_WIDTH=$(echo -e "$CLASS_NAME\n$PROPERTIES\n$METHODS" | awk '{ if (length > max) max = length } END { print max }')
BLOCK_WIDTH=$((MAX_WIDTH + 4))

# Generate the UML class block
# Center the class name
PADDING=$(( (BLOCK_WIDTH - ${#CLASS_NAME}) / 2 ))
printf ' %.0s' $(seq 1 $PADDING)
echo "$CLASS_NAME"
printf '%.0s_' $(seq 1 $BLOCK_WIDTH)
echo
echo
echo "$PROPERTIES"
printf '%.0s_' $(seq 1 $BLOCK_WIDTH)
echo
echo
echo "$METHODS"
