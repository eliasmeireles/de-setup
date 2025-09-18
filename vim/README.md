# Vim/Neovim Development Environment Setup

A comprehensive development environment setup for Vim and Neovim with enhanced Go development capabilities, modern LSP integration, and professional IDE-like features.

## 📁 Project Structure

```
vim/
├── .vimrc          # Vim configuration (compatible with both Vim and Neovim)
├── init.vim        # Neovim-specific configuration
├── setup           # Installation script
└── README.md       # This file
```

## 🚀 Features

### Core Features
- **Modern LSP Integration** - Full Language Server Protocol support
- **Smart Autocompletion** - Context-aware code completion
- **Advanced Linting** - Real-time error detection and fixing
- **Auto-formatting** - Automatic code formatting on save
- **Multi-theme Support** - Gruvbox, Molokai, and Desert themes
- **Enhanced Syntax Highlighting** - Rich syntax highlighting for multiple languages

### Go Development Features
- **gopls Integration** - Official Go language server
- **Auto-import Management** - Automatic import handling with goimports
- **Advanced Linting** - golangci-lint, staticcheck, go vet integration
- **Code Actions** - Automatic struct tag generation, interface implementation
- **Test Integration** - Built-in test running and coverage
- **Debug Support** - Integrated debugging capabilities

## 📋 Prerequisites

### Required Dependencies
```bash
# Install basic tools
sudo apt update && sudo apt install -y curl git build-essential

# Install Go (latest version)
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Install Node.js (for some LSP features)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install ripgrep (for enhanced search)
sudo apt install ripgrep

# Install fd (for file finding)
sudo apt install fd-find
```

### Install Vim/Neovim
```bash
# Install Vim
sudo apt install vim

# Install Neovim (latest stable)
sudo apt install neovim

# Or install latest Neovim from AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

### Install Go Tools
```bash
# Install Go language server
go install golang.org/x/tools/gopls@latest

# Install Go development tools
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
```

### Install Nerd Fonts (Optional but Recommended)
```bash
# Download and install a Nerd Font for icons
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
fc-cache -fv
```

## 🛠️ Installation

### Quick Setup
```bash
# Navigate to the vim directory
cd /path/to/de-setup/vim

# For Vim users
cp .vimrc ~/.vimrc

# For Neovim users
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

# Make setup script executable and run it
chmod +x setup
./setup
```

### Manual Installation

#### For Vim (.vimrc)
```bash
# Copy the configuration
cp .vimrc ~/.vimrc

# Install vim-plug (plugin manager)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Open Vim and install plugins
vim +PlugInstall +qall

# Install Go binaries
vim +GoInstallBinaries +qall
```

#### For Neovim (init.vim)
```bash
# Copy the configuration
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

# Install vim-plug for Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Open Neovim and install plugins

vim +PlugClean +PlugInstall +qall

# Install Go binaries
nvim +GoUpdateBinaries +qall
```

## ⌨️ Key Mappings and Commands

### Leader Key
The leader key is set to `,` (comma). All leader-based commands start with `,`.

### File Navigation
| Command | Description |
|---------|-------------|
| `<F2>` | Find current file in NERDTree |
| `<F3>` | Toggle NERDTree |
| `<F4>` | Toggle Tagbar |
| `,e` | Open FZF file finder |
| `,b` | Open buffer list |
| `,y` | Command history |

### Go Development
| Command | Description |
|---------|-------------|
| `,r` | Run current Go file |
| `,t` | Run Go tests |
| `,gt` | Toggle test coverage |
| `,i` | Show Go info |
| `,l` | Run metalinter |
| `,rb` | Build Go files |
| `Ctrl+g` | Go to declarations |
| `,dr` | Go to declarations in directory |
| `,dd` | Go to definition (vertical split) |
| `,dv` | Show documentation (vertical) |
| `,db` | Open documentation in browser |

### LSP Features (Neovim)
| Command | Description |
|---------|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Show hover documentation |
| `<Ctrl+Space>` | Trigger completion |
| `<Tab>` | Navigate completion (next) |
| `<Shift+Tab>` | Navigate completion (previous) |

### Completion Features (Vim)
| Command | Description |
|---------|-------------|
| `<Ctrl+j>` | Next completion suggestion |
| `<Ctrl+k>` | Previous completion suggestion |
| `<Ctrl+Space>` | Manual completion trigger |

### Code Editing
| Command | Description |
|---------|-------------|
| `,/` | Toggle comment |
| `gcc` | Comment/uncomment line |
| `gc` | Comment/uncomment selection |
| `,<space>` | Clear search highlight |

### Git Integration
| Command | Description |
|---------|-------------|
| `,ga` | Git add current file |
| `,gc` | Git commit |
| `,gsh` | Git push |
| `,gll` | Git pull |
| `,gs` | Git status |
| `,gb` | Git blame |
| `,gd` | Git diff |
| `,o` | Open current line on GitHub |

### Window Management
| Command | Description |
|---------|-------------|
| `,h` | Horizontal split |
| `,v` | Vertical split |
| `Ctrl+h/j/k/l` | Navigate between windows |
| `Tab` | Next tab |
| `Shift+Tab` | Previous tab |
| `Shift+t` | New tab |

### Buffer Management
| Command | Description |
|---------|-------------|
| `,z` or `,q` | Previous buffer |
| `,x` or `,w` | Next buffer |
| `,c` | Close buffer |

## 🎨 Themes

### Available Themes
1. **Gruvbox** (Primary) - Modern, eye-friendly theme
2. **Molokai** (Fallback) - Dark theme with good contrast
3. **Desert** (Final fallback) - Built-in Vim theme

### Switching Themes
Edit your configuration file and change the colorscheme:
```vim
" In .vimrc or init.vim
colorscheme gruvbox
" or
colorscheme molokai
" or
colorscheme desert
```

### Theme Customization
```vim
" Gruvbox options
let g:gruvbox_contrast_dark = 'medium'  " soft, medium, hard
let g:gruvbox_improved_strings = 1
let g:gruvbox_improved_warnings = 1
set background=dark  " or light
```

## 🔧 Configuration

### ALE (Linting) Configuration
```vim
" Customize linters
let g:ale_linters = {
\   'go': ['gopls', 'golint', 'go vet', 'golangci-lint', 'staticcheck'],
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\}

" Customize fixers
let g:ale_fixers = {
\   'go': ['goimports', 'gofmt'],
\   'python': ['black', 'isort'],
\   'javascript': ['prettier', 'eslint'],
\}
```

### vim-go Configuration
```vim
" Customize vim-go behavior
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_imports_autosave = 1
let g:go_mod_fmt_autosave = 1
let g:go_metalinter_autosave = 1
```

### LSP Configuration (Neovim only)
The LSP is configured in Lua within the init.vim file. Key settings:
```lua
-- LSP settings
require'lspconfig'.gopls.setup{
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}
```

## 🐛 Troubleshooting

### Common Issues

#### Plugins not loading
```bash
# Reinstall plugins
vim +PlugClean +PlugInstall +qall
# or for Neovim
nvim +PlugClean +PlugInstall +qall
```

#### Go tools not working
```bash
# Reinstall Go tools
go clean -modcache
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
```

#### LSP not working (Neovim)
```bash
# Check if gopls is installed
which gopls

# Check LSP status in Neovim
:LspInfo
```

#### Themes not loading
```bash
# Reinstall theme plugins
vim +PlugUpdate +qall
```

### Performance Issues
```vim
" Add to your config for better performance
set lazyredraw
set ttyfast
set updatetime=300
```

## 📚 Learning Resources

### Vim/Neovim Basics
- [Vim Adventures](https://vim-adventures.com/) - Interactive Vim tutorial
- [Neovim Documentation](https://neovim.io/doc/)
- [Vim Cheat Sheet](https://vim.rtorr.com/)

### Go Development
- [Go Documentation](https://golang.org/doc/)
- [Effective Go](https://golang.org/doc/effective_go.html)
- [Go by Example](https://gobyexample.com/)

### Plugin Documentation
- [vim-go](https://github.com/fatih/vim-go)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the configuration
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [vim-bootstrap](https://vim-bootstrap.com/) - Initial configuration generator
- [fatih/vim-go](https://github.com/fatih/vim-go) - Excellent Go support for Vim
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Modern completion engine
