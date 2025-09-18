#!/bin/bash

# Vim/Neovim Development Environment Setup Script
# Supports Ubuntu/Debian and macOS
# Author: Elias Meireles

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            OS="ubuntu"
            PACKAGE_MANAGER="apt"
        elif command -v yum &> /dev/null; then
            OS="centos"
            PACKAGE_MANAGER="yum"
        else
            log_error "Unsupported Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install package manager for macOS
install_homebrew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        log_success "Homebrew installed successfully"
    else
        log_info "Homebrew already installed"
    fi
}

# Update package manager
update_packages() {
    log_info "Updating package manager..."
    
    case $OS in
        "ubuntu")
            sudo apt update && sudo apt upgrade -y
            ;;
        "macos")
            brew update && brew upgrade
            ;;
    esac
    
    log_success "Package manager updated"
}

# Install basic dependencies
install_basic_deps() {
    log_info "Installing basic dependencies..."
    
    case $OS in
        "ubuntu")
            sudo apt install -y \
                curl \
                git \
                build-essential \
                software-properties-common \
                apt-transport-https \
                ca-certificates \
                gnupg \
                lsb-release \
                wget \
                unzip
            ;;
        "macos")
            # Most basic tools come with macOS or Xcode Command Line Tools
            if ! command_exists git; then
                xcode-select --install
            fi
            
            brew install curl wget
            ;;
    esac
    
    log_success "Basic dependencies installed"
}

# Install Vim and Neovim
install_vim_neovim() {
    log_info "Installing Vim and Neovim..."
    
    case $OS in
        "ubuntu")
            # Install Vim
            sudo apt install -y vim
            
            # Install Neovim (latest stable)
            if ! command_exists nvim; then
                # Try package manager first
                sudo apt install -y neovim || {
                    # Fallback to AppImage
                    log_warning "Installing Neovim via AppImage..."
                    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
                    chmod u+x nvim.appimage
                    sudo mv nvim.appimage /usr/local/bin/nvim
                }
            fi
            ;;
        "macos")
            brew install vim neovim
            ;;
    esac
    
    log_success "Vim and Neovim installed"
}

# Install Go
install_go() {
    if command_exists go; then
        log_info "Go already installed: $(go version)"
        return
    fi
    
    log_info "Installing Go..."
    
    case $OS in
        "ubuntu")
            # Remove any existing Go installation
            sudo rm -rf /usr/local/go
            
            # Download and install latest Go
            GO_VERSION="1.21.5"
            ARCH=$(uname -m)
            case $ARCH in
                "x86_64") GO_ARCH="amd64" ;;
                "aarch64") GO_ARCH="arm64" ;;
                *) log_error "Unsupported architecture: $ARCH"; exit 1 ;;
            esac
            
            wget "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
            sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
            rm "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
            
            # Add to PATH
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
            echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
            export PATH=$PATH:/usr/local/go/bin
            ;;
        "macos")
            brew install go
            
            # Add GOPATH to shell profile
            echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc
            ;;
    esac
    
    # Reload PATH
    export PATH=$PATH:$(go env GOPATH)/bin 2>/dev/null || true
    
    log_success "Go installed: $(go version 2>/dev/null || echo 'Go installed, restart shell to use')"
}

# Install Node.js
install_nodejs() {
    if command_exists node; then
        log_info "Node.js already installed: $(node --version)"
        return
    fi
    
    log_info "Installing Node.js..."
    
    case $OS in
        "ubuntu")
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        "macos")
            brew install node
            ;;
    esac
    
    log_success "Node.js installed: $(node --version)"
}

# Install development tools
install_dev_tools() {
    log_info "Installing development tools..."
    
    case $OS in
        "ubuntu")
            sudo apt install -y \
                ripgrep \
                fd-find \
                universal-ctags \
                silversearcher-ag \
                fzf
            
            # Create symlink for fd if needed
            if ! command_exists fd && command_exists fdfind; then
                sudo ln -sf $(which fdfind) /usr/local/bin/fd
            fi
            ;;
        "macos")
            brew install \
                ripgrep \
                fd \
                universal-ctags \
                the_silver_searcher \
                fzf
            ;;
    esac
    
    log_success "Development tools installed"
}

# Install Go tools
install_go_tools() {
    log_info "Installing Go development tools..."
    
    # Ensure Go is in PATH
    export PATH=$PATH:/usr/local/go/bin:$(go env GOPATH)/bin 2>/dev/null || true
    
    if ! command_exists go; then
        log_warning "Go not found in PATH, skipping Go tools installation"
        return
    fi
    
    # Install Go tools (using versions compatible with Go 1.23.4)
    go install golang.org/x/tools/gopls@v0.16.1
    go install golang.org/x/tools/cmd/goimports@v0.25.0
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install honnef.co/go/tools/cmd/staticcheck@latest
    go install github.com/fatih/gomodifytags@latest
    go install github.com/josharian/impl@latest
    
    log_success "Go tools installed"
}

# Install Nerd Fonts
install_nerd_fonts() {
    log_info "Installing Nerd Fonts..."
    
    case $OS in
        "ubuntu")
            mkdir -p ~/.local/share/fonts
            cd ~/.local/share/fonts
            
            # Download popular Nerd Fonts
            fonts=(
                "DroidSansMono"
                "FiraCode"
                "JetBrainsMono"
            )
            
            for font in "${fonts[@]}"; do
                if [ ! -f "${font}*.ttf" ] && [ ! -f "${font}*.otf" ]; then
                    log_info "Downloading ${font} Nerd Font..."
                    curl -fLo "${font}.zip" \
                        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
                    unzip -o "${font}.zip" -x "*.txt" "*.md"
                    rm "${font}.zip"
                fi
            done
            
            # Refresh font cache
            fc-cache -fv
            cd - > /dev/null
            ;;
        "macos")
            # Install via Homebrew Cask (using updated tap)
            brew install --cask \
                font-droid-sans-mono-nerd-font \
                font-fira-code-nerd-font \
                font-jetbrains-mono-nerd-font
            ;;
    esac
    
    log_success "Nerd Fonts installed"
}

# Install vim-plug
install_vim_plug() {
    log_info "Installing vim-plug..."
    
    # For Vim
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        log_success "vim-plug installed for Vim"
    fi
    
    # For Neovim
    NVIM_PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
    if [ ! -f "$NVIM_PLUG_DIR/plug.vim" ]; then
        curl -fLo "$NVIM_PLUG_DIR/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        log_success "vim-plug installed for Neovim"
    fi
}

# Setup configurations
setup_configs() {
    log_info "Setting up Vim/Neovim configurations..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Backup existing configs
    [ -f ~/.vimrc ] && cp ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d_%H%M%S)
    [ -f ~/.config/nvim/init.vim ] && cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup.$(date +%Y%m%d_%H%M%S)
    
    # Copy new configs
    cp "$SCRIPT_DIR/.vimrc" ~/.vimrc
    
    mkdir -p ~/.config/nvim
    cp "$SCRIPT_DIR/init.vim" ~/.config/nvim/init.vim
    
    log_success "Configurations copied"
}

# Install plugins
install_plugins() {
    log_info "Installing Vim plugins..."
    
    # Install Vim plugins
    if command_exists vim; then
        vim +PlugClean! +PlugInstall +qall
        log_success "Vim plugins installed"
    fi
    
    # Install Neovim plugins
    if command_exists nvim; then
        nvim +PlugClean! +PlugInstall +qall
        log_success "Neovim plugins installed"
    fi
}

# Install Go binaries for vim-go
install_vim_go_binaries() {
    log_info "Installing vim-go binaries..."
    
    if command_exists vim && command_exists go; then
        vim +GoInstallBinaries +qall 2>/dev/null || true
    fi
    
    if command_exists nvim && command_exists go; then
        nvim +GoUpdateBinaries +qall 2>/dev/null || true
    fi
    
    log_success "vim-go binaries installed"
}

# Print final instructions
print_final_instructions() {
    log_header "INSTALLATION COMPLETE!"
    
    echo -e "${GREEN}✅ Vim and Neovim are configured with Go development features${NC}"
    echo -e "${GREEN}✅ All plugins and tools have been installed${NC}"
    echo ""
    
    log_info "Key features available:"
    echo "  • Modern LSP integration (Neovim)"
    echo "  • Smart autocompletion"
    echo "  • Advanced Go linting and formatting"
    echo "  • Auto-import management"
    echo "  • Multiple themes (Gruvbox, Molokai, Desert)"
    echo "  • Enhanced syntax highlighting"
    echo ""
    
    log_info "Quick start commands:"
    echo "  • vim <file>     - Open file in Vim"
    echo "  • nvim <file>    - Open file in Neovim"
    echo "  • F3             - Toggle file tree"
    echo "  • ,e             - Open file finder"
    echo "  • ,r             - Run Go file"
    echo "  • ,t             - Run Go tests"
    echo ""
    
    log_warning "Please restart your terminal or run 'source ~/.bashrc' (Linux) or 'source ~/.zshrc' (macOS)"
    log_info "Read the README.md for complete documentation and key mappings"
}

# Main installation function
main() {
    log_header "VIM/NEOVIM DEVELOPMENT ENVIRONMENT SETUP"
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
    
    # Detect OS
    detect_os
    
    # Install package manager for macOS
    if [[ $OS == "macos" ]]; then
        install_homebrew
    fi
    
    # Installation steps
    update_packages
    install_basic_deps
    install_vim_neovim
    install_go
    install_nodejs
    install_dev_tools
    install_go_tools
    install_nerd_fonts
    install_vim_plug
    setup_configs
    install_plugins
    install_vim_go_binaries
    
    # Final instructions
    print_final_instructions
}

# Run main function
main "$@"
