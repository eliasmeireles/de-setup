#!/bin/bash

# VS Code Extensions Export Script
# This script exports the currently installed VS Code extensions to extensions.txt
# Usage: ./export-extensions.sh [TARGET]
# TARGET: code (default), windsurf, cursor, or any VS Code variant

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-code}"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

echo "Exporting $TARGET extensions..."

# Check if target command is available
if ! command -v "$TARGET" &> /dev/null; then
    echo "Error: $TARGET command not found. Please make sure $TARGET is installed and in your PATH."
    exit 1
fi


# Export extensions
echo "# $TARGET Extensions List" > "$EXTENSIONS_FILE"
echo "# Generated on: $(date)" >> "$EXTENSIONS_FILE"
echo "# Target: $TARGET" >> "$EXTENSIONS_FILE"
echo "" >> "$EXTENSIONS_FILE"

# Get list of installed extensions
"$TARGET" --list-extensions >> "$EXTENSIONS_FILE"

echo "Extensions exported to: $EXTENSIONS_FILE"
echo "Total extensions: $("$TARGET" --list-extensions | wc -l)"
