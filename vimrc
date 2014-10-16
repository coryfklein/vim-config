" ===== VUNDLE =====
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" :PluginList          - list configured plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'drmingdrmer/xptemplate'
Plugin 'kien/ctrlp.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'tfnico/vim-gradle'
Plugin 'pangloss/vim-javascript'
Plugin 'html5.vim'

call vundle#end()            " required
filetype plugin indent on    " required
" ===== END VUNDLE =====

" KEY MAPPINGS
" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<CR>
" <Bar>:echo<CR>A

" Commands to insert and append a single character
nnoremap gi :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap ga :exec "normal a".nr2char(getchar())."\e"<CR>

" Map Y to yank to the end of the line
map Y y$

" Map ;h to a.vim :A, swap header and c file
nmap ,h :A<CR>
nmap ,H :AV<CR>

" Easier buffer navigation
map gn :bn<cr>
map gN :bp<cr>
map gp :bp<cr>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Don't prompt to save when reading from stdin
" au StdinReadPost * :set nomodified

" Shortcuts for tab close, tab edit, and tab find
nmap ,tx :tabc<CR>
nmap ,to :tabo<CR>
nmap ,te :tabe 
nmap ,tf :tabf 

nmap __ :wa<CR>

" Change the current working directory to the one containing this file
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,cr :lcd <c-r>=FindGitDirOrRoot()<cr><cr>

" Cory-friendly half-page scrolling
nmap <C-d> Lzz
nmap <C-u> Hzz

if version >= 703
  set undofile                " Save undo's after file closes
  set undodir=/Users/coryklein/.vim/undo " where to save undo histories
  set undolevels=1000         " How many undos
  set undoreload=10000        " number of lines to save for undo
endif

" SETTINGS
" Automatically save the file when you are leaving a buffer or window
" set autowriteall

" highlight search matches
set hlsearch

" backspace over everything
set backspace=indent,eol,start

" Don't wrap text
set nowrap

set nu

" White space error
set listchars=tab:>-,trail:-
set list

" Color
set bg=light
colorscheme wombat256mod
syntax on
set t_Co=256

" Indents, Tabs, & Misc
set tabstop=2
set shiftwidth=2
set expandtab

" ctags config
set tags=tags;/

" Don't use swap files
set noswapfile

" Indentation
set autoindent

" vi compatibility
set nocompatible

" Search features
set incsearch  " scroll to search items as I type them
set ignorecase
set smartcase  " don't ignore case if uppercase is present

set scrolloff=3 " scroll buffer when within x lines of top/bottom

" Don't hide lines that don't fit in the window
set display+=lastline

" Yank everything to system clipboard
" See http://stackoverflow.com/questions/8757395/can-vim-use-the-system-clipboards-by-default
" set clipboard=unnamedplus

" Yank everything to system clipboard (Mac OS X)
set clipboard=unnamed

" Set color of tab line fill to black
hi TabLine term=underline cterm=underline ctermfg=LightGray ctermbg=DarkGray gui=underline guibg=DarkGray
hi TabLineFill term=bold cterm=bold ctermbg=Black
hi VertSplit term=bold cterm=bold ctermfg=DarkGray ctermbg=NONE
hi StatusLine term=bold cterm=bold ctermbg=LightGray ctermfg=DarkGray
hi StatusLineNC term=reverse ctermbg=DarkGray ctermfg=LightGray

" Run the publish.sh script in the local directory
nnoremap <C-P> :call SaveAndPublish()<CR>
function! SaveAndPublish()
    :w
    :! ./publish.sh &
endfunction

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

function! SortLines() range
    silent execute a:firstline . "," . a:lastline . 's/^\(.*\)$/\=strlen( submatch(0) ) . " " . submatch(0)/'
    silent execute a:firstline . "," . a:lastline . 'sort n'
    silent execute a:firstline . "," . a:lastline . 's/^\d\+\s//'
endfunction

" File type recognition
filetype plugin indent on

" Command to diffput to all buffers
" See http://stackoverflow.com/questions/19594802/diffput-to-multiple-buffers
function! GetDiffBuffers()
    return map(filter(range(1, winnr('$')), 'getwinvar(v:val, "&diff")'), 'winbufnr(v:val)')
endfunction

function! DiffPutAll()
    for bufspec in GetDiffBuffers()
        execute 'diffput' bufspec
    endfor
endfunction

command! -range=-1 -nargs=* Dpa call DiffPutAll()

function! FindGitDirOrRoot()
  let curdir = expand('%:p:h')
  let gitdir = finddir('.git', curdir . ';')
  if gitdir != ''
    return substitute(gitdir, '\/\.git$', '', '')
  else
    return '/'
  endif
endfunction

set wildignore+=*.class,*.git,*/out/*

"-----------------------------------------------------------------------------
" CtrlP plugin configuration
"-----------------------------------------------------------------------------
let g:ctrlp_working_path_mode = 'ra'

nmap ,fb :CtrlPBuffer<cr>
nmap ,ff :CtrlP .<cr>
nmap ,fF :execute ":CtrlP " . expand('%:p:h')<cr>
nmap ,fr :CtrlP<cr>
nmap ,fm :CtrlPMixed<cr>
