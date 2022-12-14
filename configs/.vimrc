" VIM CONFIGURATION

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
let $LANG='en'
set langmenu=en
set visualbell " Don't beep.
set noerrorbells " Don't beep.
let mapleader = ','
inoremap jf <Esc>

" plug.vim CONFIGURATION
call plug#begin('~/vimfiles/plugged')

    Plug 'tomtom/tcomment_vim'
    " tcomment_vim config
    noremap <silent><Leader>cc :TComment<CR>

    Plug 'sheerun/vim-polyglot'
    let g:javascript_plugin_jsdoc = 1

    Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

    Plug 'editorconfig/editorconfig-vim'

    Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger="<s-Enter>"
    let g:UltiSnipsJumpForwardTrigger="<s-Enter>"

    Plug 'honza/vim-snippets'

    Plug 'jiangmiao/auto-pairs'
    let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}

    Plug 'misterbuckley/vim-definitive'
    noremap <F12> :FindDefinition<CR>

    Plug 'matze/vim-move'
    let g:move_key_modifier = 'C'

    Plug 'mattn/emmet-vim'

    Plug 'Valloric/YouCompleteMe'
    let g:ycm_global_ycm_extra_conf = '~/vimfiles/.ycm_extra_conf.py'
    set rtp+=~/vimfiles/plugged/YouCompleteMe
    set runtimepath+=~/vimfiles/plugged/YouCompleteMe

    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1

    Plug 'preservim/nerdtree'
    " Start NERDTree. If a file is specified, move the cursor to its window.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
    map <C-n> :NERDTreeToggle<CR>
    let NERDTreeShowFiles=1
    let NERDTreeShowHidden=1
    let NERDTreeMouseMode=1
    " let g:NERDTreeDirArrowExpandable = '▸'
    " let g:NERDTreeDirArrowCollapsible = '▾'
    " let g:NERDTreeDirArrowExpandable = '»'
    " let g:NERDTreeDirArrowCollapsible = '«'

    Plug 'ryanoasis/vim-devicons'
    let g:airline_powerline_fonts = 1

call plug#end()

syntax on
syntax enable
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set nobackup
set autoread " Automatically reload files when theres a change outside Vim.
set ttyfast " Fast keyboard.
set nowrap
set ruler

" Always show the status line
set laststatus=2

set autoindent
set ai "Auto indent
set si "Smart indent

" Line Endigs
set ff=unix " The most cross platform.
set ffs=unix
set fileformat=unix
set fileformats=unix,dos
" set ff=dos
" set ff=mac

" Visual autocomplete for command menu
set wildmenu

" Default indent size
set tabstop=4
set shiftwidth=4
set smarttab

" TABs to spaces
set expandtab
set backspace=eol,start,indent

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

set showcmd

" Regular expressions
set magic

" Command history
set history=500
set undolevels=300

" Show line numbers
set number

" Highlight matching brace
set showmatch

" Binary support
" set binary

" Highlight line currently under cursor
" set cursorline
set nocursorline

set mouse=a

" netrw CONFIGURATION
let g:netrw_winsize= -28
let g:netrw_liststyle= 3
let g:netrw_sort_sequence= '[\/]$,*'
let g:netrw_browse_split= 3

set omnifunc=syntaxcomplete#Complete

autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype html set omnifunc=htmlcomplete#CompleteTags

autocmd FileType css set omnifunc=csscomplete#CompleteCSS

autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd Filetype javascript syntax=javascript
augroup Filetype javascript syntax=javascript

autocmd Filetype json setlocal ts=2 sw=2 expandtab

set t_Co=256
set background=dark
"color desert

" terminal-mode:
:tnoremap <Esc> <C-\><C-n>

" ---------------------------
" Resources:
" https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md
