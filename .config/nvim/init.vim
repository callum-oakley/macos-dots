call plug#begin('~/.config/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'fatih/vim-go'
Plug 'gutenye/json5.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mindriot101/vim-yapf'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tsiemens/vim-aftercolors'
Plug 'wellle/targets.vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue'] }
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

" tabs
set expandtab
set shiftwidth=2
set smarttab
set tabstop=2

" filetype specific settings
autocmd FileType c setlocal shiftwidth=4 tabstop=4
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 listchars=tab:\ \ ,trail:·
autocmd FileType markdown let g:AutoPairs = {}
autocmd FileType rust let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType swift setlocal shiftwidth=4 tabstop=4
autocmd BufWritePre *.py :Yapf

" uncomment to format all js files on save
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue PrettierAsync

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
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#parser = 'babylon'

" keymaps
inoremap <home> <esc>I

nmap <leader>c gc
nmap <leader>j :setlocal fo+=a<cr>Go<cr>## <esc><leader>tso<cr>

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
nnoremap <leader>fa :setlocal fo+=a<cr>
nnoremap <leader>ff gqq
nnoremap <leader>fm :setlocal fo-=a<cr>
nnoremap <leader>hq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <leader>i :BLines<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>o o<esc>O
nnoremap <leader>p :.! python3 -<cr>
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
nnoremap K "_D
nnoremap U <c-r>
nnoremap Y y$
nnoremap c "_c
nnoremap k "_d
nnoremap kk "_dd
nnoremap x "_x

vnoremap <PageDown> 9<down>
vnoremap <PageUp> 9<up>
vnoremap <cr> :
vnoremap <home> ^
vnoremap <leader>p :! python3 -<cr>
vnoremap c "_c
vnoremap x "_x
