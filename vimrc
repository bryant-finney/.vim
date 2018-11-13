" Maintainer: Bryant Finney

" ----- preferences for normal mode -----
" map ctrl-delete functionality:
nnoremap <C-Del> dw
nnoremap <C-kDel> dw

" map ctrl+d to delete the current line
nnoremap <C-D> :dl<Enter>


" ----- preferences for insert mode -----
" map ctrl+d to delete the current line
inoremap <C-D> <Esc>:dl<Enter>

" ----- general preferences -----
set tabstop=4 shiftwidth=4 expandtab

" ----- get plugins through vim-plug (cmd 'Plug')
call plug#begin('~/.vim/plugged')

" Add documentation for the vim-plug wiki
Plug 'https://github.com/junegunn/vim-plug.git'

" Add vim-snippets to allow vim to insert templates with a hotkey
Plug 'https://github.com/honza/vim-snippets.git'

call plug#end()
