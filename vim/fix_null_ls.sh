#!/bin/bash

# Fix null-ls.nvim compatibility issue
# This script replaces the deprecated null-ls.nvim with none-ls.nvim

echo "🔧 Fixing null-ls.nvim compatibility issue..."

# Copy updated configurations
echo "📋 Copying updated configurations..."
cp init.vim ~/.config/nvim/init.vim
cp .vimrc ~/.vimrc

# Remove old plugin directory to ensure clean install
echo "🗑️  Removing old null-ls plugin..."
rm -rf ~/.config/nvim/plugged/null-ls.nvim

# Clean and reinstall plugins
echo "🧹 Cleaning old plugins..."
nvim +PlugClean! +qall

echo "📦 Installing updated plugins..."
nvim +PlugInstall +qall

# Check if installation was successful
if [ -d ~/.config/nvim/plugged/none-ls.nvim ]; then
    echo "✅ none-ls.nvim installed successfully!"
else
    echo "⚠️  Warning: none-ls.nvim may not have installed properly"
    echo "   Try running: nvim +PlugInstall manually"
fi

echo "✅ Fix applied! The null-ls.nvim error should be resolved."
echo "ℹ️  Changes made:"
echo "   • Replaced 'jose-elias-alvarez/null-ls.nvim' with 'nvimtools/none-ls.nvim'"
echo "   • Updated LSP configuration for Neovim 0.11+ compatibility"
echo "   • Cleaned and reinstalled all plugins"
echo ""
echo "🚀 You can now use Neovim without the null-ls error!"
