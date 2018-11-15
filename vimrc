" Maintainer: Bryant Finney

" ----- preferences for normal mode -----
" map ctrl-delete functionality:
nnoremap <C-Del> ved
nnoremap <C-kDel> ved

" map ctrl+shift+delete to delete to the end of the word (instad of moving to
" the beginning of the next)
nnoremap <C-S-Del> vEhd

" map ctrl+d to delete the current line
nnoremap <C-D> :dl<Enter>

" map ctrl+backspace to delete the previous word
nnoremap <C-BS> vbd

" map backspace to delete the previous characer
nnoremap <BS> X

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
nnoremap <C-Right> e
nnoremap <C-Left> b
nnoremap <C-S-Right> E
nnoremap <C-S-Left> B

" ----- preferences for insert mode -----
" map ctrl+d to delete the current line
inoremap <C-D> <C-[>:dl<Enter>

" map ctrl+backspace to delete to the beginning of the current word
inoremap <C-S-BS> <C-[>vBdi

" map ctrl+backspace to delete the previous word
inoremap <C-BS> <C-W>

" map ctrl+delete this causes the cursor to shift one place to the right when
" deleting the first word on the line
inoremap <C-Del> <C-[>lvedi

" map ctrl+shift+delete to delete to the end of the WORD 
inoremap <C-S-Del> <C-[>lvEhdi

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
inoremap <C-Right> <C-[>ea
inoremap <C-Left> <C-[>bi
inoremap <C-S-Right> <C-[>Ea
inoremap <C-S-Left> <C-[>Bi

" ----- preferences for visual mode -----
" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
vnoremap <C-Right> e
vnoremap <C-Left> b
vnoremap <C-S-Right> Eh
vnoremap <C-S-Left> B

" ----- general preferences -----
set tabstop=4 shiftwidth=4 expandtab
set wrap!
set colorcolumn=89
set number
set iskeyword-=_
set autochdir
set cursorline
set whichwrap=b,s,[,]
set backspace=indent,eol,start
set expandtab
set smartindent
set copyindent
set preserveindent
set pumheight=10

" ----- get plugins through vim-plug (cmd 'Plug')
call plug#begin('~/.vim/plugged')

" Add documentation for the vim-plug wiki
Plug 'https://github.com/junegunn/vim-plug.git'

" Add vim-snippets to allow vim to insert templates with a hotkey
Plug 'https://github.com/honza/vim-snippets.git'

" Add vim-matlab (repo was created from MatLab File Exchange post)
Plug 'https://github.com/raingo/vim-matlab.git'

call plug#end()
