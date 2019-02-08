" Maintainer: Bryant Finney

" ----- preferences for normal mode -----
" map original semicolon behavior to new <C-Del> behavior
nnoremap ;; ;

" map semicolon to 'q:'
nmap ; q:


" map ctrl-delete functionality:
nnoremap <C-Del> ved

" map ctrl+shift+delete to delete to the end of the word (instad of moving to
" the beginning of the next)
nnoremap <C-S-Del> vEd

" map ctrl+d to delete the current line
nnoremap <C-D> :dl<Enter>

" map ctrl+backspace to delete the previous word
" nnoremap <C-BS> vbd

" todo: mapping this on top of <C-BS> does strange things on the external
" keyboard
" nnoremap  vbd                         " and the builtin keyboard

" map backspace to delete the previous characer
" nnoremap <BS> X

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
nnoremap <C-Right> e
nnoremap <C-Left> b
nnoremap <C-S-Right> E
nnoremap <C-S-Left> B

" map shift tab to unindent
nnoremap <S-Tab> v<S-<>


" ----- preferences for insert mode -----
" map ctrl+d to delete the current line
inoremap <C-D> <C-[>:dl<Enter>

" map ctrl+backspace to delete to the beginning of the current word
" inoremap <C-S-BS> <C-[>vBdi

" map ctrl+backspace to delete the previous word
inoremap <C-BS> <C-W>

" map ctrl+bs as ^H this on top of <C-BS> in order to add support outside of gvim
inoremap  <C-W>

" map ctrl+space to overload ctrl+n (for autocomplete)
inoremap <C-Space> <C-P>

" map ctrl+delete this causes the cursor to shift one place to the right when
" deleting the first word on the line
inoremap <C-Del> <C-[>lvedi
" also map the delete key on the laptop's builtin keyboard
" inoremap <C-kDel> <C-[>lvedi

" map ctrl+shift+delete to delete to the end of the WORD
inoremap <C-S-Del> <C-[>lvEhdi
" also map the delete key on the laptop's builtin keyboard
" inoremap <C-S-kDel> <C-[>lvEhdi

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
inoremap <C-Right> <C-[>ea
inoremap <C-Left> <C-[>bi
inoremap <C-S-Right> <C-[>Ea
inoremap <C-S-Left> <C-[>Bi

" map shift tab to unindent
inoremap <S-Tab> <C-[>v<S-<>


" ----- preferences for command mode -----
cmap <C-BS> <C-W>
" legion is a desktop machine, so this is okay-ish:
cmap  <C-W>

" ----- preferences for visual mode -----
" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
vnoremap <C-Right> e
vnoremap <C-Left> b
vnoremap <C-S-Right> Eh
vnoremap <C-S-Left> B

" map shift tab to unindent
vnoremap <S-Tab> <S-<>         " TODO: this really needs to be 'delete previous spaces'


" ----- general preferences -----
set tabstop=4 shiftwidth=4 expandtab
set nowrap
set colorcolumn=87
set textwidth=87
set number
"set iskeyword-=_
set autochdir
set cursorline
set whichwrap=b,s,[,]
set backspace=indent,eol,start
set expandtab
set smartindent
set copyindent
set preserveindent
set pumheight=10
set showmatch         " toggle showmatch to jump the cursor back to the opening bracket
set hlsearch

highlight ColorColumn ctermfg=7 ctermbg=248

" configure autocompletion display options
set wildmenu
set wildmode=longest,full

" define a function (called on :w) to remove trailing spaces and to replace
" tab characters with four spaces
fun! TrimWhitespace()
    let l:save = winsaveview()

    %s/\s\+$//e
    %s/\t/    /e
    call winrestview(l:save)
endfun

" configure vim to automatically remove trailing whitespace
autocmd FileType c,cpp,markdown,matlab,tex,vim autocmd BufWritePre <buffer> nested :call TrimWhitespace()

" tabs -> spaces on write (for python)
autocmd FileType c,cpp,matlab,python autocmd BufWritePre <buffer> nested %s/\t/    /e

" use the black autoformatter for python
autocmd FileType python autocmd BufWritePre <buffer> nested :Black

" set specifically for matlab, but probably generally useful:
filetype indent on
source $VIMRUNTIME/macros/matchit.vim
source $VIMRUNTIME/ftplugin/man.vim


" ----- configure vim-latex -----
let g:tex_flavor='latex'
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:


" ----- get plugins through vim-plug (cmd 'Plug')
call plug#begin('~/.vim/plugged')

" Add documentation for the vim-plug wiki
Plug 'https://github.com/junegunn/vim-plug.git'

" Add vim-snippets to allow vim to insert templates with a hotkey
Plug 'https://github.com/honza/vim-snippets.git'

" Add vim-matlab (repo was created from MatLab File Exchange post)
Plug 'https://github.com/raingo/vim-matlab.git'

" Add UltiSnips for template insertion
Plug 'SirVer/ultisnips'

" Add vim-latex for editing LaTeX documents
Plug 'vim-latex/vim-latex'

" Add the Black plugin for python development
Plug 'ambv/black'

" Add the Jedi plugin
Plug 'davidhalter/jedi-vim'
" ----- configure vim-matlab -----

" generate links for each file (so that the plugin files are sourced
" !bash $HOME/.vim/create_links.sh

" generate the help tags
helptags $HOME/.vim/plugged/vim-matlab/doc

" integrate the 'make' command (use mlint)
autocmd BufEnter *.m compiler mlint

call plug#end()

