call plug#begin('~/.config/nvim/plugged')
Plug 'cespare/vim-toml'
Plug 'chiel92/vim-autoformat'
Plug 'dense-analysis/ale'
Plug 'elixir-editors/vim-elixir'
Plug 'fatih/vim-go'
Plug 'guns/vim-sexp'
Plug 'gutenye/json5.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-mix-format'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier'
Plug 'psf/black', { 'tag': '19.10b0' }
Plug 'reasonml-editor/vim-reason-plus'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
call plug#end()

set breakindent
set cinoptions=(4,m1:0
set clipboard=unnamedplus
set expandtab
set fo-=tcro
set guicursor=n-v-c-sm:block,i-ci-ve-r-cr-o:hor20
set hidden
set linebreak
set list
set listchars=tab:▸·,trail:·
set nojoinspaces
set ruler
set scrolloff=99
set shiftwidth=4
set showcmd
set smarttab
set tabstop=4

colorscheme rubric

autocmd FileType * set fo-=o
autocmd FileType clojure let g:AutoPairs = {} " let sexp handle it
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType go setlocal noexpandtab listchars=tab:\ \ ,trail:·
autocmd FileType haskell let g:AutoPairs = {'(':')',  '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType haskell setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType html.handlebars setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType markdown let g:AutoPairs = {}
autocmd FileType rust let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType sh setlocal fo-=t
autocmd FileType svg setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.graphql,*.html PrettierAsync
autocmd BufWritePre *.py execute ':Black'

let g:ale_fix_on_save = 1
let g:ale_fixers = { 'haskell': ['hfmt'] }
let g:ale_linters_explicit = 1
let g:black_linelength = 80
let g:cli_fmt_autosave = 1
let g:fzf_layout = { 'down': '~16' }
let g:go_fmt_command = "goimports"
let g:haskell_indent_disable = 1
let g:mix_format_on_save = 1
let g:mix_format_silent_errors = 1
let g:prettier#autoformat = 0
let g:prettier#config#arrow_parens = 'always'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#trailing_comma = 'es5'
let g:rustfmt_autosave = 1

" implements https://tonsky.me/blog/clojurefmt
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['.']

" search for selected text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>N

" adapted from https://github.com/junegunn/fzf.vim/blob/2bf85d25e203a536edb2c072c0d41b29e8e4cc1b/plugin/fzf.vim#L60
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --colors 'path:none' --colors 'line:none' --smart-case -- ".shellescape(<q-args>), 1, {}, <bang>0)

" keymaps
let mapleader=" "

nmap <leader>c gc
vmap <leader>c gc

inoremap <m-bs> <c-w>
inoremap <home> <esc>I
inoremap <end> <esc>A

nnoremap * *N
nnoremap <PageDown> 9<down>
nnoremap <PageUp> 9<up>
nnoremap <cr> :
nnoremap <end> $
nnoremap <esc> :noh<cr><esc>
nnoremap <home> ^
nnoremap <leader> <nop>
nnoremap <leader>* g*N
nnoremap <leader><c-down> ddGp
nnoremap <leader><c-up> ddggP
nnoremap <leader>= <c-w>=
nnoremap <leader>E :e 
nnoremap <leader>N :bp<cr>
nnoremap <leader>O O<esc>O
nnoremap <leader>S :noautocmd w<cr>
nnoremap <leader>a <nop>
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>ce :CljEval<cr>
nnoremap <leader>cs :CljsEval<cr>
nnoremap <leader>d /<<<<<<<\\|=======\\|\|\|\|\|\|\|\|\\|>>>>>>><cr>
nnoremap <leader>e :Files<cr>
nnoremap <leader>f gq
nnoremap <leader>fa :setlocal fo+=a<cr>
nnoremap <leader>ff gqq
nnoremap <leader>fm :setlocal fo-=a<cr>
nnoremap <leader>hp O{-# LANGUAGE  #-}<esc>B<left>i
nnoremap <leader>hq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <leader>i :BLines<cr>
nnoremap <leader>l /.\{81,\}<cr>
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
nnoremap <tab> :b#<cr>
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
vnoremap <end> $
vnoremap <home> ^
vnoremap <leader>f gq
vnoremap <leader>p :! python3 -<cr>
vnoremap c "_c
vnoremap k "_d
vnoremap x "_x
