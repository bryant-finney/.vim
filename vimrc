" Maintainer: Bryant Finney

" ----- preferences for normal mode -----
" map original semicolon behavior to new <C-Del> behavior
nnoremap ;; ;

" map semicolon to 'q:'
nmap ; q:

" move a line down using alt/cmd + shift + j
nnoremap <S-D-J> :m+<CR>
nnoremap <M-J> :m+<CR>

" move a line up using alt/cmd + shift + k
nnoremap <S-D-K> :m-2<CR>
nnoremap <M-K> :m-2<CR>

" copy a line up/down using ctrl + alt/cmd + shift + k/j
nnoremap <C-S-D-J> :t.<CR>
nnoremap <C-S-D-K> :t-<CR>
if !has('macunix')
  nnoremap <M-NL> :t.<CR>
  nnoremap <M-C-K> :t-<CR>
endif

" delete to the beginning of a line using alt/cmd + backspace
nnoremap <D-BS> v^d
if !has('macunix')
  nnoremap <M-BS> v^d
endif

" undo with alt/cmd + z
nnoremap <D-z> u

" redo with alt/cmd + shift z
nnoremap <S-D-z> <C-R>

" write with alt/cmd + s
nnoremap <D-s> :w<CR>
nnoremap <M-s> :w<CR>

" map ctrl-delete functionality:
nnoremap <C-Del> ved

" use alt + delete, but only on mac
if has('macunix')
  nnoremap <M-Del> ved
endif

" map ctrl+shift+delete to delete to the end of the word (instad of moving to
" the beginning of the next)
nnoremap <C-S-Del> vEd

" map ctrl+d to delete the current line
nnoremap <C-D> :dl<Enter>

" map ctrl+backspace to delete the previous word
nnoremap <C-BS> vbd

" todo: mapping this on top of <C-BS> does strange things on the external
" keyboard
" nnoremap  vbd                         " and the builtin keyboard

" map backspace to delete the previous characer
noremap <BS> X

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
nnoremap <C-Right> e
nnoremap <C-Left> b
nnoremap <C-S-Right> E
nnoremap <C-S-Left> B
if has('macunix')
  nnoremap <M-Right> e
  nnoremap <M-Left> b
  nnoremap <M-S-Right> E
  nnoremap <M-S-Left> B
endif

" alt / cmd + left and alt / cmd + right to move to the beginning and end of the line
nnoremap <D-Right> $
nnoremap <D-Left> 0

" cmd + up and cmd + down to move to the beginning and end of the file
nnoremap <D-Up> gg^
nnoremap <D-Down> G$

" map split transitions for when operating remotely from Windows
nnoremap Wh <C-W><C-H>
nnoremap Wj <C-W><C-j>
nnoremap Wl <C-W><C-l>
nnoremap Wk <C-W><C-K>

" move windows (splits) around
nnoremap WH <C-W>H
nnoremap WJ <C-W>J
nnoremap WL <C-W>L
nnoremap WK <C-W>K

" resize splits with similar mappings as transitions
nnoremap <C-W><C-K> <C-W>+
nnoremap <C-W><C-J> <C-W>-
nnoremap <C-W><C-L> <C-W>>
nnoremap <C-W><C-H> <C-W><

nnoremap W<C-K> <C-W>+
nnoremap W<C-J> <C-W>-
nnoremap W<C-L> <C-W>>
nnoremap W<C-H> <C-W><

" map shift tab to unindent
nnoremap <S-Tab> v<S-<>

" map tab and shift+tab to jump to the next occurence using shemshi
nnoremap <S-Tab> :Semshi goto name prev<CR>

" map 'rr' to replace a node using Semshi
nnoremap rr :Semshi rename<CR>

nnoremap AJ :ALENext<CR>
nnoremap AK :ALEPrevious<CR>

" Open vimagit pane
nnoremap gs :Magit<CR>       " git status

func! Indent(ind)
  " change the indentation of the current line while maintaining the relative position
  "     of the cursor
  " ref: https://vi.stackexchange.com/a/18340
  if &sol
    set nostartofline
  endif
  let vcol = virtcol('.')
  if a:ind
    norm! >>
    exe "norm!". (vcol + shiftwidth()) . '|'
  else
    norm! <<
    exe "norm!". (vcol - shiftwidth()) . '|'
  endif
endfunc

nnoremap >> :call Indent(1)<CR>
nnoremap << :call Indent(0)<CR>

" use cmd + ] and cmd + [ to indent / dedent with the custom indent function
nnoremap <D-]> :call Indent(1)<CR>
nnoremap <D-[> :call Indent(0)<CR>

" ----- preferences for insert mode -----
" map ctrl+d to delete the current line
inoremap <C-D> <C-[>:dl<Enter>

" map ctrl+backspace to delete to the beginning of the current word
" inoremap <C-S-BS> <C-[>vBdi

" move a line down using alt/cmd + shift + j
inoremap <S-D-J> <C-[>:m+<CR>a
if !has('macunix')
  inoremap <M-J> <C-[>:m+<CR>a
else
  inoremap <D-J> <C-[>:m+<CR>a
end

" move a line up using alt/cmd + shift + k
inoremap <S-D-K> <C-[>:m-2<CR>a
inoremap <M-K> <C-[>:m-2<CR>a

" copy a line down using ctrl + alt/cmd + shift + j
inoremap <C-S-D-J> <C-[>:t.<CR>a
inoremap <M-NL> <C-[>:t.<CR>a

" copy a line up using ctrl + alt/cmd + shift + k
inoremap <C-S-D-K> <C-[>:t.<CR>a
inoremap <M-C-K> <C-[>:t.<CR>a

" delete to the beginning of a line using alt/cmd + backspace
inoremap <D-BS> <C-[>v^di
inoremap <M-BS> <C-[>v^di

" delete to the end of a line using cmd + delete
inoremap <D-Del> <C-[>ld$a

" undo with alt/cmd + z
inoremap <D-z> <C-[>u

" redo with alt/cmd + shift z
inoremap <S-D-z> <C-[><C-r>

" write with alt/cmd + s
inoremap <D-s> <C-[>:w<CR>i

" map ctrl + backspace to delete the previous word
inoremap <C-BS> <C-W>

if has('macunix')
  inoremap <M-BS> <C-W>
else
  inoremap <D-BS> <C-W>
endif

" map ctrl+bs as ^H this on top of <C-BS> in order to add support outside of gvim
" NOTE: does not work (WSL)
inoremap  <C-W>

" map ctrl+space to overload ctrl+n (for autocomplete)
inoremap <C-Space> <C-N>

" map ctrl+delete this causes the cursor to shift one place to the right when
" deleting the first word on the line
inoremap <C-Del> <C-[>lvedi

if has('macunix')
  inoremap <M-Del> <C-[>lvedi
endif

" map ctrl+shift+delete to delete to the end of the WORD
inoremap <C-S-Del> <C-[>lvEhdi

" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
inoremap <C-S-Right> <C-[>Ea
inoremap <C-S-Left> <C-[>Bi

if has('macunix')
  inoremap <M-Right> <C-Right>
  inoremap <M-Left> <C-Left>
  inoremap <M-S-Right> <C-[>Ea
  inoremap <M-S-Left> <C-[>Bi
else
  inoremap <C-Right> <C-[>ea
  inoremap <C-Left> <C-[>bi
endif

" map shift tab to unindent
inoremap <S-Tab> <C-[>v<S-<>

" alt / cmd + left and alt / cmd + right to move to the beginning and end of the line
inoremap <D-Right> <C-[>$a
inoremap <D-Left> <C-[>0i
if !has('macunix')
  inoremap <M-Right> <C-[>$a
  inoremap <M-Left> <C-[>0i
endif

" alt / cmd + up and alt / cmd + down to move to the beginning and end of the file
inoremap <D-Up> <C-[>gg^i
inoremap <D-Down> <C-[>G$a
if !has('macunix')
  inoremap <M-Up> <C-[>gg^i
  inoremap <M-Down> <C-[>G$a
endif

" use cmd + ] and cmd + [ to indent / dedent with the custom indent function
inoremap <D-]> <C-[>:call Indent(1)<CR>a
inoremap <D-[> <C-[>:call Indent(0)<CR>a

" suggest emoji completion by triggering the user-defined completion function
inoremap <C-e> <C-X><C-U>

" ----- preferences for command mode -----
cmap <C-BS> <C-W>

" legion is a desktop machine, so this is okay-ish:
cmap  <C-W>

if has('macunix')
  " map ctrl + backspace to delete the previous word
  cmap <M-BS> <C-W>
endif

" ----- preferences for visual mode -----
" map ctrl+left and ctrl+right to move to word boundaries instead of WORD
" boundaries; supplement with ctrl+shift keys
vnoremap <C-Right> e
vnoremap <C-Left> b
vnoremap <C-S-Right> Eh
vnoremap <C-S-Left> B

" move a line down using alt/cmd + shift + j
vnoremap <S-D-J> :m'>+<CR>gv=gv

" move a line up using alt/cmd + shift + k
vnoremap <S-D-K> :m-2<CR>gv=gv

" use cmd + ] and cmd + [ to indent / dedent with the custom indent function
vnoremap <D-]> :call Indent(1)<CR>
vnoremap <D-[> :call Indent(0)<CR>

" alt / cmd + left and alt / cmd + right to move to the beginning and end of the line
vnoremap <D-Right> $
vnoremap <D-Left> 0

" map split transitions for when operating remotely from Windows
vnoremap Wh <C-W><C-H>
vnoremap Wj <C-W><C-j>
vnoremap Wl <C-W><C-l>
vnoremap Wk <C-W><C-K>

" move windows (splits) around
vnoremap WH <C-W>H
vnoremap WJ <C-W>J
vnoremap WL <C-W>L
vnoremap WK <C-W>K

" resize splits with similar mappings as transitions
vnoremap <C-W><C-K> <C-W>+
vnoremap <C-W><C-J> <C-W>-
vnoremap <C-W><C-L> <C-W>>
vnoremap <C-W><C-H> <C-W><

" copy selection up/down using ctrl + alt/cmd + shift + k/j
vnoremap <expr> <C-S-D-J> (visualmode() == "v" ? "V" : "")."y'<Pgv"
vnoremap <expr> <C-S-D-K> (visualmode() == "v" ? "V" : "")."y'>$pgv"


" ----- general preferences -----
" colorscheme comes first
colorscheme slate

" make the background color transparent
hi Normal guibg=NONE ctermbg=NONE

"set iskeyword-=_
set noautochdir
set backspace=indent,eol,start
set colorcolumn=120
set conceallevel=2
set copyindent
set cursorline
set cursorcolumn
set hlsearch
set nowrap
set number
set preserveindent
set pumheight=10
set showmatch         " toggle showmatch to jump the cursor back to the opening bracket
set smartindent
set tabstop=4 shiftwidth=4 expandtab
set textwidth=120
set whichwrap=b,s,[,]
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
autocmd FileType c,cpp,markdown,tex,vim autocmd BufWritePre <buffer> nested :call TrimWhitespace()

" tabs -> spaces on write (for python)
autocmd FileType c,cpp,python autocmd BufWritePre <buffer> nested %s/\t/    /e

" configure vim to automatically format json text on write
com! FormatJSON %!python -m json.tool
autocmd FileType json autocmd BufWritePre <buffer> nested :FormatJSON

" use the black autoformatter for python
"   update 2019-03-18 11:25: ALE should autmatically call black
" autocmd FileType python autocmd BufWritePre <buffer> nested :Black

" use tags generated by ctags and linked into this directory
" autocmd BufReadPre *.py setlocal tags=~/.vim/tags

" ----- configure vim-flake8 -----
" let g:flake8_show_in_gutter=1
" let g:flake8_show_in_file=1
" let g:flake8_show_quickfix=1
" execute flake8 on write:
" autocmd BufWritePost *.py call Flake8()

" set originally for matlab, but probably generally useful:
filetype indent on
source $VIMRUNTIME/macros/matchit.vim
source $VIMRUNTIME/ftplugin/man.vim

let g:python3_host_prog = "python3"

" configure ALE
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'sh': ['shfmt'],
\   'graphql': ['prettier'],
\   'markdown': ['prettier'],
\   'python': ['ruff', 'ruff_format'],
\   'toml': ['prettier'],
\}
let g:ale_lint_on_insert_leave = 1
" mypy is firing a 'No library stub' error
"let g:ale_linters = {
"\   'markdown': ['markdownlint', 'proselint'],
"\   'python': ['flake8', 'pydocstyle', 'mypy', 'bandit'],
"\}
let g:ale_linters = {
\   'markdown': ['markdownlint', 'proselint'],
\   'python': ['mypy', 'ruff', 'ruff_format'],
\   'sh': ['shellcheck'],
\}
let g:ale_list_window_size = 5
let g:ale_open_list = 1
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry= 1
let g:ale_python_bandit_auto_pipenv = 1
let g:ale_python_flake8_auto_pipenv = 1
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_pydocstyle_auto_pipenv = 1
let g:ale_python_pylint_auto_pipenv = 1
let g:ale_python_pylint_auto_poetry = 1
let g:ale_python_ruff_format_auto_poetry = 1
let g:ale_set_highlights = 1
let g:ale_set_loclist = 1
let g:ale_sh_shfmt_options = '-i 2 -ci -kp'

"let g:ale_set_quickfix = 1
let g:ale_virtualtext_cursor = 1

let g:ale_terraform_checkov_options = '--config-file etc/checkov.yaml'
let g:ale_terraform_tfsec_options = '--config-file etc/tfsec.yaml'

" configure vim-surround
let g:surround_40 = "(\r)"
let g:surround_91 = "[\r]"
let g:surround_123 = "{\r}"

" configure vim-markdown
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal = 1

" for future expansion:
let g:airline#extensions#ale#enabled = 1

" ----- configure deoplete -----
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
let g:deoplete#enable_at_startup = 1

" ----- configure vim-latex -----
let g:tex_flavor = 'latex'
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

" Add UltiSnips for template insertion
" Plug 'SirVer/ultisnips'

" Add vim-latex for editing LaTeX documents
Plug 'vim-latex/vim-latex'

if ! has('nvim')
  " Add the Black plugin for python development
  Plug 'psf/black', { 'branch': 'stable' }

  " Add the Jedi plugin
  Plug 'davidhalter/jedi-vim'
endif

" Add the vim-surround plugin for surrounding with quotes, brackets, etc
Plug 'tpope/vim-surround'

" Add plugin for formatting and error checking shell scripts
Plug '42wim/vim-shfmt'

" Add plugin for performing static analysis + style checks with flake8
" Plug 'nvie/vim-flake8'

" Add plugin for checking docstrings with pydocstyle
Plug 'w0rp/ale'

" Add a json formatter plugin
Plug 'elzr/vim-json'

" Add Tabular (dependency of vim-markdown)
Plug 'godlygeek/tabular'

" Add a markdown style checker/formatter
Plug 'plasticboy/vim-markdown'

" Add plugin to auto close parens/braces/brackets/quotes
Plug 'jiangmiao/auto-pairs'

" Add plugin for better python syntax highlighting
Plug 'wookayin/semshi', {'do': ':UpdateRemotePlugins'}

" Add plugin for taking notes using RST
Plug 'gu-fan/riv.vim'

" Highlight changes in the gutter
Plug 'airblade/vim-gitgutter', {'branch': 'main'}

" Create a pain for showing file diffs
Plug 'jreybert/vimagit'

Plug 'github/copilot.vim'

" support multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" automatically generate tags for source files
" TODO: stopped working on WSL
" Plug 'ludovicchabant/vim-gutentags'

" terraform linting and completion
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'neomake/neomake'
Plug 'preservim/tagbar'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1

Plug 'jparise/vim-graphql'

" support emoji suggestions 😃
Plug 'junegunn/vim-emoji'

call plug#end()

if has('nvim')
  lua require('config')
endif

set expandtab


" ----- pretty colors -----
func! PrettyColors()
    highlight Comment ctermfg=gray guifg=darkgray

    highlight link pythonDocstring pythonComment
    highlight link pythonOperator pythonStatement

    highlight ColorColumn ctermbg=Black guibg=gray20
    highlight CursorLine guibg=gray20 ctermbg=black
    highlight CursorColumn guibg=gray20 ctermbg=black
    highlight DiffText cterm=bold ctermbg=7 gui=bold guibg=LightGray
    highlight Search ctermfg=248 ctermbg=10 guifg=wheat guibg=peru
    highlight Function guifg=darkgoldenrod
    highlight Include gui=bold cterm=bold ctermfg=5 guifg=plum3
    highlight LineNr ctermfg=LightGray guifg=gray50
    highlight String gui=italic guifg=Turquoise4

    highlight semshiSelected gui=underline cterm=underline ctermbg=LightGray ctermfg=NONE guibg=gray30 guifg=NONE
    highlight semshiImported gui=bold cterm=bold guifg=darkgoldenrod ctermfg=214
    highlight semshiImported guifg=darkgoldenrod ctermfg=214
endfun

fun! GitPrettyColors()
    call PrettyColors()
    highlight Constant ctermfg=69 guifg=CornFlowerBlue
    highlight PreProc cterm=bold gui=bold ctermfg=255 guifg=Grey93
    highlight Identifier cterm=bold gui=bold ctermfg=11 guifg=gold
    highlight gitHead cterm=bold gui=bold ctermfg=14 guifg=cyan
endfun

fun TodoPrettyColors()
    syntax match MyTodo contained "\v.*todo|TODO.*"
    highlight link MyTodo Todo
endf

call PrettyColors()
call TodoPrettyColors()

autocmd FileType markdown,python,sh,vim call PrettyColors()|:call TodoPrettyColors()
autocmd FileType markdown,python,sh,vim call TodoPrettyColors()
autocmd FileType git,gitcommit call GitPrettyColors()

command Reload source $MYVIMRC

" note: this was causing the cursor to jump around on save
" command Emojize %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
" autocmd BufWritePre * Emojize

function! Emoji(findstart, base)
  if a:findstart
    let s:startcol = col('.') - 1
    let s:regex = printf('[%s]', join(uniq(sort(split(join(emoji#list(), ''), '\c'))), ''))

    while s:startcol > 0 && getline('.')[s:startcol - 1] =~ s:regex
      let s:startcol -= 1
    endwhile
    return s:startcol - 1
  endif

  return emoji#complete(a:findstart, a:base)
endfunction

" slightly_smiling_face -> 😊
set completefunc=Emoji
