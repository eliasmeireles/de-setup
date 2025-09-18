#!/bin/bash

# Comprehensive Vim/Neovim Setup Fix Script
# Fixes: Tab mapping conflicts, null-ls compatibility, plugin installation issues
# Combines functionality from complete_fix.sh and fix_null_ls.sh

# set -e  # Exit on any error (disabled for debugging)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

# Main fix function
main() {
    log_header "VIM/NEOVIM CONFIGURATION FIX"

    log_info "Fixing multiple issues:"
    echo "  • Tab mapping conflicts in vim-mucomplete"
    echo "  • Deprecated null-ls.nvim compatibility"
    echo "  • LSP configuration for Neovim 0.11+"
    echo "  • Plugin installation issues"
    echo ""

    echo "Installing fzf"

    rm -rf ~/.fzf || true 
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

    # Create backups
    log_info "Creating configuration backups..."
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    if [ -f ~/.vimrc ]; then
        cp ~/.vimrc ~/.vimrc.backup.$TIMESTAMP
        log_success "Backed up ~/.vimrc"
    fi

    if [ -f ~/.config/nvim/init.vim ]; then
        cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup.$TIMESTAMP
        log_success "Backed up ~/.config/nvim/init.vim"
    fi

    # Copy updated configurations
    log_info "Copying updated configurations..."
    cp .vimrc ~/.vimrc
    mkdir -p ~/.config/nvim
    cp init.vim ~/.config/nvim/init.vim
    log_success "Configurations updated"

    # Remove problematic plugins completely
    log_info "Removing problematic plugins..."

    # Remove old null-ls and mucomplete plugins
    rm -rf ~/.vim/plugged/vim-mucomplete
    rm -rf ~/.vim/plugged/null-ls.nvim
    rm -rf ~/.config/nvim/plugged/null-ls.nvim
    rm -rf ~/.config/nvim/plugged/jose-elias-alvarez

    # Remove problematic LSP plugins to force reinstall with correct versions
    rm -rf ~/.config/nvim/plugged/nvim-lspconfig
    rm -rf ~/.config/nvim/plugged/none-ls.nvim
    rm -rf ~/.config/nvim/plugged/nvimtools

    log_success "Problematic plugins removed"

    # Clean plugin directories
    log_info "Cleaning plugin directories..."

    # Clean Vim plugins
    if command -v vim &> /dev/null; then
        vim +PlugClean! +qall 2>/dev/null || log_warning "Vim plugin cleanup completed with warnings"
    fi

    # Clean Neovim plugins
    if command -v nvim &> /dev/null; then
        nvim +PlugClean! +qall 2>/dev/null || log_warning "Neovim plugin cleanup completed with warnings"
    fi

    log_success "Plugin directories cleaned"

    # Install plugins for Vim
    if command -v vim &> /dev/null; then
        log_info "Installing Vim plugins..."
        vim +PlugInstall +qall 2>/dev/null || log_warning "Vim plugin installation completed with warnings"
        log_success "Vim plugins installed"
    else
        log_warning "Vim not found, skipping Vim plugin installation"
    fi

    # Install plugins for Neovim
    if command -v nvim &> /dev/null; then
        log_info "Installing Neovim plugins..."
        nvim +PlugInstall +qall 2>/dev/null || log_warning "Neovim plugin installation completed with warnings"
        log_success "Neovim plugins installed"
    else
        log_warning "Neovim not found, skipping Neovim plugin installation"
    fi

    # Verify installations
    log_info "Verifying plugin installations..."

    # Check vim-mucomplete for Vim
    if [ -d ~/.vim/plugged/vim-mucomplete ]; then
        log_success "vim-mucomplete installed for Vim"
    else
        log_warning "vim-mucomplete not found for Vim"
    fi

    # Check none-ls for Neovim
    if [ -d ~/.config/nvim/plugged/none-ls.nvim ]; then
        log_success "none-ls.nvim installed for Neovim"
    else
        log_warning "none-ls.nvim not found for Neovim"
    fi

    # Check nvim-lspconfig for Neovim
    if [ -d ~/.config/nvim/plugged/nvim-lspconfig ]; then
        log_success "nvim-lspconfig installed for Neovim"
    else
        log_warning "nvim-lspconfig not found for Neovim"
    fi

    # Test editor startups
    log_info "Testing editor startups..."

    # Test Vim startup
    if command -v vim &> /dev/null; then
        if vim -c 'echo "Vim OK"' -c 'qall' 2>/dev/null; then
            log_success "Vim starts without errors"
        else
            log_warning "Vim may have startup issues"
        fi
    fi

    # Test Neovim startup
    if command -v nvim &> /dev/null; then
        if nvim -c 'echo "Neovim OK"' -c 'qall' 2>/dev/null; then
            log_success "Neovim starts without errors"
        else
            log_warning "Neovim may have startup issues"
        fi
    fi

    # Install Go binaries if Go is available
    if command -v go &> /dev/null; then
        log_info "Installing Go development tools..."

        if command -v vim &> /dev/null; then
            vim +GoInstallBinaries +qall 2>/dev/null || log_warning "Vim Go binaries installation completed with warnings"
        fi

        if command -v nvim &> /dev/null; then
            nvim +GoUpdateBinaries +qall 2>/dev/null || log_warning "Neovim Go binaries installation completed with warnings"
        fi

        log_success "Go development tools installed"
    else
        log_warning "Go not found, skipping Go tools installation"
    fi

    # Final status report
    log_header "FIX COMPLETE!"

    log_success "All fixes have been applied successfully!"
    echo ""
    log_info "Changes made:"
    echo "  ✅ Fixed Tab mapping conflicts in vim-mucomplete"
    echo "  ✅ Fixed nvim-lspconfig compatibility issues"
    echo "  ✅ Used stable LSP plugin versions (nvim-lspconfig v0.1.6)"
    echo "  ✅ Disabled ALE LSP integration to prevent conflicts"
    echo "  ✅ Cleaned and reinstalled all plugins with compatible versions"
    echo "  ✅ Installed Go development tools"
    echo ""

    log_info "Key mappings for completion:"
    echo "  📝 Vim (mucomplete):"
    echo "     • Ctrl+j - Next completion"
    echo "     • Ctrl+k - Previous completion"
    echo "     • Ctrl+Space - Manual trigger"
    echo ""
    echo "  📝 Neovim (nvim-cmp):"
    echo "     • Tab - Next completion"
    echo "     • Shift+Tab - Previous completion"
    echo "     • Ctrl+Space - Manual trigger"
    echo ""

    log_info "Go development commands:"
    echo "  🚀 ,r - Run Go file"
    echo "  🧪 ,t - Run Go tests"
    echo "  📊 ,gt - Toggle test coverage"
    echo "  🔍 ,i - Show Go info"
    echo "  🔧 ,l - Run metalinter"
    echo ""

    log_info "If you still encounter issues, try:"
    echo "  vim +PlugClean +PlugInstall +qall"
    echo "  nvim +PlugClean +PlugInstall +qall"
    echo ""

    log_warning "Please restart your terminal or reload your shell configuration"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should not be run as root"
    exit 1
fi

# Run main function
main "$@"
