" Maintainer: Bryant Finney

" ----- preferences for normal mode -----
" map ctrl-delete functionality:
nnoremap <C-Del> ved
nnoremap <C-kDel> ved

" map ctrl+d to delete the current line
nnoremap <C-D> :dl<Enter>

" map ctrl+backspace to delete the previous word
nnoremap <C-BS> vb<del>

" map backspace to delete the previous characer
nnoremap <BS> X


" ----- preferences for insert mode -----
" map ctrl+d to delete the current line
inoremap <C-D> <Esc>:dl<Enter>

" map ctrl+backspace to delete the previous word
inoremap <C-BS> <C-W>

" map ctrl+delete this causes the
" cursor to shift one place to the right when  *not* deleting
" the last word on the line
inoremap <C-Del> <C-[><Right>ve<Del>a

" ----- general preferences -----
set tabstop=4 shiftwidth=4 expandtab
set wrap!
set colorcolumn=89
set number
set iskeyword-=_

" ----- get plugins through vim-plug (cmd 'Plug')
call plug#begin('~/.vim/plugged')

" Add documentation for the vim-plug wiki
Plug 'https://github.com/junegunn/vim-plug.git'

" Add vim-snippets to allow vim to insert templates with a hotkey
Plug 'https://github.com/honza/vim-snippets.git'

call plug#end()
