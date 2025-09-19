" vim-bootstrap 2025-09-18 13:55:36

"*****************************************************************************
"" Vim-Plug core
"*****************************************************************************
let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

let g:vim_bootstrap_langs = "go,html,python,typescript"
let g:vim_bootstrap_editor = "vim"				" nvim or vim
let g:vim_bootstrap_theme = "molokai"
let g:vim_bootstrap_frams = ""

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/grep.vim'
Plug 'vim-scripts/CSApprox'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'dense-analysis/ale'
Plug 'Yggdroot/indentLine'
Plug 'editor-bootstrap/vim-bootstrap-updater'
Plug 'tpope/vim-rhubarb' " required by fugitive to :GBrowse
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'  " Additional theme


if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif
let g:make = 'gmake'
if exists('make')
        let g:make = 'make'
endif
Plug 'Shougo/vimproc.vim', {'do': g:make}

"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

"" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"*****************************************************************************
"" Custom bundles
"*****************************************************************************

" go
"" Go Lang Bundle
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}

" LSP configuration (for Neovim only)
if has('nvim')
  Plug 'neovim/nvim-lspconfig'

  " Autocompletion (Neovim only)
  Plug 'hrsh7th/nvim-cmp'           " Completion engine (Neovim)
  Plug 'hrsh7th/cmp-nvim-lsp'      " LSP completion source
  Plug 'hrsh7th/cmp-buffer'        " Buffer completion source
  Plug 'hrsh7th/cmp-path'          " Path completion source
  Plug 'hrsh7th/cmp-cmdline'       " Command line completion
  Plug 'L3MON4D3/LuaSnip'          " Snippet engine
  Plug 'saadparwaiz1/cmp_luasnip'  " Snippet completion source
endif

" CoC (Conquer of Completion) - Universal completion engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Alternative completion for classic Vim (only load if not Neovim)
if !has('nvim')
  " Disable mucomplete default mappings before loading
  let g:mucomplete#no_mappings = 1
  Plug 'lifepillar/vim-mucomplete'  " Lightweight completion for Vim
endif

" Linting and diagnostics (none-ls for Neovim only)
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'      " Required for none-ls (Neovim)
  Plug 'nvimtools/none-ls.nvim'     " LSP diagnostics, formatting, and code actions (maintained fork)
endif

" Icons (if you have nerd-fonts installed)
Plug 'ryanoasis/vim-devicons'

" Better syntax highlighting
Plug 'sheerun/vim-polyglot'

" Theme Manager (Neovim only)
if has('nvim')
  Plug 'zaldih/themery.nvim'
endif

" Material Design themes
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'hzchirs/vim-material'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ayu-theme/ayu-vim'

" JetBrains-inspired themes
Plug 'doums/darcula'
Plug 'blueshirts/darcula'

" Popular themes from vimcolorschemes collection
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'EdenEast/nightfox.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'rose-pine/neovim', { 'as': 'rose-pine' }
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'projekt0n/github-nvim-theme'

" Additional curated dark themes from vimcolorschemes
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'chriskempson/base16-vim'
Plug 'mhartington/oceanic-next'
Plug 'jacoborus/tender.vim'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'lifepillar/vim-solarized8'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/edge'
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'Rigellute/rigel'
Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'
Plug 'nanotech/jellybeans.vim'
Plug 'jnurmine/Zenburn'


" html
"" HTML Bundle
Plug 'hail2u/vim-css3-syntax'
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'


" python
"" Python Bundle
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}


" typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'



"*****************************************************************************
"" Additional Plugins (Advanced)
"*****************************************************************************

" fzf - Fuzzy finder for files, buffers, and more
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = 'right:60%'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

" Enhanced fzf configuration with preview (similar to your shell aliases)
let g:fzf_preview_script = expand('~/.fzf/bin/fzf-preview.sh')

" Configure preview options with file info display
if filereadable(g:fzf_preview_script)
  let g:fzf_files_options = '--preview "' . g:fzf_preview_script . ' {}" --bind "focus:transform-header:file --brief {}" --preview-window=right:60%'
else
  " Fallback preview options with file info
  if executable('bat')
    let g:fzf_files_options = '--style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'
  elseif executable('highlight')
    let g:fzf_files_options = '--style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'
  else
    let g:fzf_files_options = '--style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'
  endif
endif

" Set global fzf options for fzf.vim commands
let $FZF_DEFAULT_OPTS = g:fzf_files_options


" vim-easymotion - Vim motions on speed!
Plug 'easymotion/vim-easymotion'

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


"*****************************************************************************
"*****************************************************************************

"" Include user's extra bundle
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

" --- Enhanced Appearance Settings ---
set number              " Absolute number on current line
set relativenumber      " Relative lines for navigation
set cursorline          " Highlight current line
set ruler               " Show cursor position
set colorcolumn=120     " Mark column 120
set showmatch           " Show matching brackets
set nowrap              " Don't wrap lines
set noerrorbells        " No error bells
set visualbell          " Use visual bell instead of beeping

" Enhanced search settings
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive when uppercase present
set hlsearch            " Highlight search results
set incsearch           " Incremental search

" Enhanced indentation
set smartindent         " Smart indentation
set autoindent          " Auto indentation

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Enhanced Searching
set hlsearch            " Highlight search results
set incsearch           " Incremental search (show matches as you type)
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive when uppercase present
set wrapscan            " Wrap around when searching
set magic               " Enable regular expressions

" Enhanced search completion
set wildmenu            " Command-line completion
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.pyc,*.class,*.git,*.svn,*.hg
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tar.gz,*.tar.bz2
set wildignore+=*/node_modules/*,*/bower_components/*

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1

" --- Theme Configuration ---
" Enable true colors if supported
if has('termguicolors')
  set termguicolors
endif

" Set background first
set background=dark

" Theme settings (must be set before colorscheme)
" Sonokai settings (primary theme)
let g:sonokai_style = 'default'  " Options: default, atlantis, andromeda, shusia, maia, espresso
let g:sonokai_better_performance = 1
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0
let g:sonokai_diagnostic_text_highlight = 1
let g:sonokai_diagnostic_line_highlight = 1
let g:sonokai_diagnostic_virtual_text = 'colored'

" Material settings (fallback)
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'

" OneDark settings (fallback)
let g:onedark_termcolors = 256
let g:onedark_terminal_italics = 1

" Enhanced syntax highlighting
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" Better line numbers and cursor (like the first image)
set number
set nocursorcolumn  " Remove column highlighting for cleaner look
set cursorline

" Enhanced visual settings for better appearance
set showmode
set showcmd
set laststatus=2
set noshowmode  " Hide mode since airline shows it

" Better colors and contrast
if has('nvim') || has('termguicolors')
  set termguicolors
endif

" Transparent background (optional - uncomment if you want transparency)
" autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE
" autocmd VimEnter * hi NonText guibg=NONE ctermbg=NONE

" Set colorscheme with fallback (after plugins are loaded)
autocmd VimEnter * call SetColorScheme()

function! SetColorScheme()
  try
    " Try Sonokai first (beautiful high-contrast theme)
    colorscheme sonokai
    let g:airline_theme = 'sonokai'
  catch
    try
      colorscheme gruvbox
      let g:airline_theme = 'gruvbox'
    catch
      colorscheme desert
      let g:airline_theme = 'dark'
    endtry
  endtry
endfunction

" Manual theme switching commands (try these to match first image)
" :colorscheme onedark | let g:airline_theme = 'onedark' | AirlineRefresh
" :colorscheme material | let g:airline_theme = 'material' | AirlineRefresh
" :colorscheme tokyonight-storm | let g:airline_theme = 'tokyonight' | AirlineRefresh
" :colorscheme nord | let g:airline_theme = 'nord' | AirlineRefresh
" :colorscheme palenight | let g:airline_theme = 'palenight' | AirlineRefresh

" Quick theme switching functions
command! ThemeSonokai colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! ThemeOneDark colorscheme onedark | let g:airline_theme = 'onedark' | AirlineRefresh
command! ThemeMaterial colorscheme material | let g:airline_theme = 'material' | AirlineRefresh
command! ThemeTokyoNight colorscheme tokyonight-storm | let g:airline_theme = 'tokyonight' | AirlineRefresh
command! ThemeNord colorscheme nord | let g:airline_theme = 'nord' | AirlineRefresh

" Sonokai style variants (restart vim after changing)
command! SonokaiDefault let g:sonokai_style = 'default' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! SonokaiAtlantis let g:sonokai_style = 'atlantis' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! SonokaiAndromeda let g:sonokai_style = 'andromeda' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! SonokaiShusia let g:sonokai_style = 'shusia' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! SonokaiMaia let g:sonokai_style = 'maia' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh
command! SonokaiEspresso let g:sonokai_style = 'espresso' | colorscheme sonokai | let g:airline_theme = 'sonokai' | AirlineRefresh


" Gruvbox contrast options:
" let g:gruvbox_contrast_dark = 'soft'      " Softer contrast
" let g:gruvbox_contrast_dark = 'medium'    " Default (currently active)
" let g:gruvbox_contrast_dark = 'hard'      " Higher contrast

" Force theme reload function
command! ReloadTheme call SetColorScheme()


" Better command line completion
set wildmenu

" mouse support
set mouse=a

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = ''
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1


  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif

endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0

set scrolloff=3


"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline configuration for better appearance
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

" Enhanced airline appearance
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#fnamemod = ':t'

" Show encoding and file format
let g:airline#parts#ffenc#skip_expected_string = ''
let g:airline_section_y = '%{&fenc ? &fenc : &enc}[%{&ff}]'
let g:airline_section_z = '%3p%% %l:%c'

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" NERDTree configuration
let g:NERDTreeChDirMode=0
let g:NERDTreeIgnore=['node_modules','\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,*node_modules/
nnoremap <silent> <F2> :NERDTreeCWD<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" terminal emulation
nnoremap <silent> <leader>sh :terminal<CR>


"*****************************************************************************
"" Commands
"*****************************************************************************
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Git commit --verbose<CR>
noremap <Leader>gsh :Git push<CR>
noremap <Leader>gll :Git pull<CR>
noremap <Leader>gs :Git<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiffsplit<CR>
noremap <Leader>gr :GRemove<CR>

" session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" Themery keybinding (Neovim only)
if has('nvim')
  nnoremap <leader>th :Themery<CR>
else
  " Manual theme switching for regular Vim
  nnoremap <leader>th1 :colorscheme gruvbox<CR>:let g:airline_theme='gruvbox'<CR>:AirlineRefresh<CR>
  nnoremap <leader>th2 :colorscheme material<CR>:let g:airline_theme='material'<CR>:AirlineRefresh<CR>
  nnoremap <leader>th3 :colorscheme molokai<CR>:let g:airline_theme='molokai'<CR>:AirlineRefresh<CR>
endif

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
" Enhanced file finder with preview (similar to your laff/vff aliases)
nnoremap <silent> <leader>e :call fzf#run(fzf#wrap({'options': g:fzf_files_options . ' -m'}))<CR>
" Alternative using fzf.vim Files command with preview
nnoremap <silent> <leader>ff :Files<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

" snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"

" ale
let g:ale_linters = {}

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
set clipboard=unnamedplus

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Enhanced Search Mappings
" Clear search highlight
nnoremap <silent> <leader><space> :noh<cr>

" Search for word under cursor
nnoremap <leader>* *<C-O>:%s///gn<CR>

" Search and replace current word
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Visual mode search for selected text
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Function for visual selection search
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\/$.*'[]^~")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.GBrowse<CR>

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" go
" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" --- Enhanced vim-go configurations ---
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"   " Use goimports for formatting and auto-import
let g:go_fmt_fail_silently = 1
let g:go_imports_autosave = 1        " Auto-import on save
let g:go_fmt_autosave = 1            " Auto-format on save
let g:go_mod_fmt_autosave = 1        " Auto-format go.mod files
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1

" Enhanced syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END

" --- Enhanced ALE (Asynchronous Lint Engine) configurations ---
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_fixers = get(g:, 'ale_fixers', {})

" Go linters and fixers
let g:ale_linters.go = ['gopls', 'golint', 'go vet', 'golangci-lint', 'staticcheck']
let g:ale_fixers.go = ['goimports', 'gofmt']

" ALE behavior
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'when_idle'
let g:ale_lint_delay = 750
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" --- LSP and Completion Configuration ---
" Enable LSP and completion features if using Neovim
if has('nvim')
lua << EOLUA
-- LSP configuration (updated for Neovim 0.11+)
local lspconfig = require('lspconfig')
lspconfig.gopls.setup{
    cmd = {"gopls"},
    filetypes = {"go", "gomod"},
    root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
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

-- Autocompletion setup
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- Command line completion
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- none-ls for additional linting and formatting
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- Go linters and formatters
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
    },
})
EOLUA

" Themery.nvim configuration (Neovim only)
if has('nvim')
lua << THEMERY_EOF
require("themery").setup({
  themes = {
    -- === DARK THEMES (vimcolorschemes collection) ===
    {
      name = "🌙 Gruvbox Dark (Recommended)",
      colorscheme = "gruvbox",
      before = [[
        vim.g.gruvbox_contrast_dark = 'hard'
        vim.g.gruvbox_improved_strings = 1
        vim.g.gruvbox_improved_warnings = 1
        vim.g.gruvbox_italic = 1
        vim.g.gruvbox_bold = 1
        vim.g.gruvbox_underline = 1
        vim.g.gruvbox_undercurl = 1
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Gruvbox Material Dark",
      colorscheme = "gruvbox-material",
      before = [[
        vim.g.gruvbox_material_background = 'medium'
        vim.g.gruvbox_material_better_performance = 1
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Tokyo Night Storm",
      colorscheme = "tokyonight-storm"
    },
    {
      name = "🌙 Tokyo Night Night",
      colorscheme = "tokyonight-night"
    },
    {
      name = "🌙 Catppuccin Mocha",
      colorscheme = "catppuccin-mocha"
    },
    {
      name = "🌙 Catppuccin Macchiato",
      colorscheme = "catppuccin-macchiato"
    },
    {
      name = "🌙 Nord",
      colorscheme = "nord",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 OneDark",
      colorscheme = "onedark",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 OneDark (joshdick)",
      colorscheme = "onedark",
      before = [[
        vim.g.onedark_termcolors = 256
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Palenight",
      colorscheme = "palenight",
      before = [[
        vim.g.palenight_terminal_italics = 1
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Ayu Dark",
      colorscheme = "ayu",
      before = [[
        vim.g.ayucolor = 'dark'
      ]]
    },
    {
      name = "🌙 Ayu Mirage",
      colorscheme = "ayu",
      before = [[
        vim.g.ayucolor = 'mirage'
      ]]
    },
    {
      name = "🌙 Oceanic Next",
      colorscheme = "OceanicNext",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Tender",
      colorscheme = "tender",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Challenger Deep",
      colorscheme = "challenger_deep",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Solarized8 Dark",
      colorscheme = "solarized8",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Edge Dark",
      colorscheme = "edge",
      before = [[
        vim.g.edge_style = 'default'
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Nightfly",
      colorscheme = "nightfly",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Moonfly",
      colorscheme = "moonfly",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Rigel",
      colorscheme = "rigel",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Iceberg",
      colorscheme = "iceberg",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Hybrid",
      colorscheme = "hybrid",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Jellybeans",
      colorscheme = "jellybeans",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Zenburn",
      colorscheme = "zenburn",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Nightfox",
      colorscheme = "nightfox"
    },
    {
      name = "🌙 Kanagawa Dragon",
      colorscheme = "kanagawa-dragon"
    },
    {
      name = "🌙 Kanagawa Wave",
      colorscheme = "kanagawa-wave"
    },
    {
      name = "🌙 Dracula",
      colorscheme = "dracula"
    },
    {
      name = "🌙 Rose Pine",
      colorscheme = "rose-pine"
    },
    {
      name = "🌙 Rose Pine Moon",
      colorscheme = "rose-pine-moon"
    },
    {
      name = "🌙 Everforest Dark",
      colorscheme = "everforest",
      before = [[
        vim.g.everforest_background = 'medium'
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 Sonokai",
      colorscheme = "sonokai"
    },
    {
      name = "🌙 Material Ocean",
      colorscheme = "material",
      before = [[
        vim.g.material_style = 'ocean'
      ]]
    },
    {
      name = "🌙 Material Darker",
      colorscheme = "material",
      before = [[
        vim.g.material_style = 'darker'
      ]]
    },
    {
      name = "🌙 Material Palenight",
      colorscheme = "material",
      before = [[
        vim.g.material_style = 'palenight'
      ]]
    },
    {
      name = "🌙 Base16 Default Dark",
      colorscheme = "base16-default-dark",
      before = [[
        vim.opt.background = 'dark'
      ]]
    },
    {
      name = "🌙 One Dark",
      colorscheme = "one",
      before = [[
        vim.opt.background = 'dark'
      ]]
    }
  },
  livePreview = true
})
THEMERY_EOF
endif
else
    " Enable mucomplete for classic Vim only
    if !has('nvim') && exists('g:loaded_mucomplete')
        let g:mucomplete#enable_auto_at_startup = 1
        let g:mucomplete#completion_delay = 1
        " Use custom mappings (Tab mapping already disabled above)
        imap <expr> <C-j> mucomplete#extend_fwd("\<C-j>")
        imap <expr> <C-k> mucomplete#extend_bwd("\<C-k>")
    endif
endif

"*****************************************************************************
"" CoC (Conquer of Completion) Configuration
"*****************************************************************************
" CoC extensions to install automatically
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-python',
  \ 'coc-go',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-eslint'
  \ ]

" CoC configuration
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c

" Always show the signcolumn
if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" html
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab


" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0

" ale
:call extend(g:ale_linters, {
    \'python': ['flake8'], })

" vim-airline
let g:airline#extensions#virtualenv#enabled = 1

" Syntax highlight
let python_highlight_all = 1


" typescript
let g:yats_host_keyword = 1



"*****************************************************************************
"*****************************************************************************

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"*****************************************************************************
"" Convenience variables
"*****************************************************************************

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif
