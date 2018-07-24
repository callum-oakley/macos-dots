call plug#begin('~/.config/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'fatih/vim-go'
Plug 'gutenye/json5.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tsiemens/vim-aftercolors'
Plug 'wellle/targets.vim'
call plug#end()

set breakindent
set clipboard=unnamedplus
set guicursor=n-v-c-sm:block,i-ci-ve-r-cr-o:hor20
set hidden
set linebreak
set list
set listchars=tab:▸·,trail:·
set relativenumber
set ruler
set scrolloff=99
set showcmd
set tildeop

" tabs
set expandtab
set shiftwidth=2
set smarttab
set tabstop=2

" filetype specific settings
autocmd FileType c setlocal shiftwidth=4 tabstop=4
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 listchars=tab:\ \ ,trail:·
autocmd FileType lhaskell setlocal fo+=ro
autocmd FileType markdown let g:AutoPairs = {}
autocmd FileType rust let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType rust setlocal tw=80
autocmd FileType swift setlocal shiftwidth=4 tabstop=4

set t_Co=256   " This is may or may not needed.

set background=light
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
colorscheme PaperColor

let mapleader=" "

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>N

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" plugin options
let g:rustfmt_autosave = 1
let g:haskell_indent_disable = 1
let g:fzf_layout = { 'down': '~16' }

" keymaps
inoremap <home> <esc>I

nmap <leader>c gc

nnoremap * *N
nnoremap <PageDown> 9<down>
nnoremap <PageUp> 9<up>
nnoremap <c-e> :m+<cr>
nnoremap <c-i> >>
nnoremap <c-n> <<
nnoremap <c-u> :m--<cr>
nnoremap <cr> :
nnoremap <esc> :noh<cr><esc>
nnoremap <home> ^
nnoremap <leader> <nop>
nnoremap <leader>* g*N
nnoremap <leader><c-down> ddGp
nnoremap <leader><c-up> ddggP
nnoremap <leader><tab> :b#<cr>
nnoremap <leader>= <c-w>=
nnoremap <leader>E :e 
nnoremap <leader>N :bp<cr>
nnoremap <leader>O O<esc>O
nnoremap <leader>a <nop>
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>d /<<<<<<<\\|=======\\|>>>>>>><cr>
nnoremap <leader>e :Files<cr>
nnoremap <leader>f gq
nnoremap <leader>ff gqq
nnoremap <leader>hq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <leader>i :BLines<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>o o<esc>O
nnoremap <leader>q :q<cr>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>s :w<cr>
nnoremap <leader>t <nop>
nnoremap <leader>t2 :set shiftwidth=2<cr>:set tabstop=2<cr>
nnoremap <leader>t4 :set shiftwidth=4<cr>:set tabstop=4<cr>
nnoremap <leader>te :set expandtab<cr>
nnoremap <leader>tn :set noexpandtab<cr>
nnoremap <leader>ts mt:r !date<cr>D"_dd`tp
nnoremap <leader>v <c-v>
nnoremap <leader>w :bd<cr>
nnoremap U <c-r>
nnoremap c "_c
nnoremap x "_x
nnoremap ~~ ~<right>

vnoremap <PageDown> 9<down>
vnoremap <PageUp> 9<up>
vnoremap <cr> :
vnoremap <home> ^
vnoremap c "_c
vnoremap x "_x
