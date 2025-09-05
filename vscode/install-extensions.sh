#!/bin/bash

# VS Code Extensions Installation Script
# This script installs VS Code extensions from extensions.txt
# Usage: ./install-extensions.sh [TARGET]
# TARGET: code (default), windsurf, cursor, or any VS Code variant

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-code}"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

echo "Installing $TARGET extensions..."

# Check if target command is available
if ! command -v "$TARGET" &> /dev/null; then
    echo "Error: $TARGET command not found. Please make sure $TARGET is installed and in your PATH."
    exit 1
fi

# Check if extensions file exists
if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo "Error: Extensions file not found: $EXTENSIONS_FILE"
    echo "Please run export-extensions.sh first or create the file manually."
    exit 1
fi

echo "Reading extensions from: $EXTENSIONS_FILE"

# Counter for installed extensions
installed_count=0
failed_count=0

# Read extensions file and install each extension
while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Remove leading/trailing whitespace
    extension=$(echo "$line" | xargs)
    
    if [ -n "$extension" ]; then
        echo "Installing: $extension"
        if "$TARGET" --install-extension "$extension" --force; then
            echo "✓ Successfully installed: $extension"
            ((installed_count++))
        else
            echo "✗ Failed to install: $extension"
            ((failed_count++))
        fi
    fi
done < "$EXTENSIONS_FILE"

echo ""
echo "Installation complete!"
echo "Successfully installed: $installed_count extensions"
if [ $failed_count -gt 0 ]; then
    echo "Failed to install: $failed_count extensions"
fi
