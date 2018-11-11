nnoremap <C-Del> dw
nnoremap <C-kDel> dw

call plug#begin('~/.vim/plugged')

" Add documentation for the vim-plug wiki
Plug 'https://github.com/junegunn/vim-plug.git'

" Add vim-snippets to allow vim to insert templates with a hotkey
Plug 'https://github.com/honza/vim-snippets.git'

call plug#end()

