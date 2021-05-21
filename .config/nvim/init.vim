call plug#begin('~/.config/nvim/plugged')
Plug 'Olical/conjure'
Plug 'Omer/vim-sparql'
Plug 'axvr/org.vim'
Plug 'bakpakin/fennel.vim'
Plug 'cespare/vim-toml'
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go'
Plug 'guns/vim-sexp'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mustache/vim-mustache-handlebars'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-surround'
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
set nofoldenable
set nojoinspaces
set ruler
set scrolloff=99
set shiftwidth=4
set showcmd
set smarttab
set splitbelow
set tabstop=4
set wrap

colorscheme rubric

autocmd BufNewFile,BufReadPost *.sparql set filetype=sparql

autocmd FileType * set fo-=o
autocmd FileType clojure let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"' }
autocmd FileType clojure setlocal lispwords+=are,cond,fdef,finally,try
autocmd FileType clojure setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType fennel let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"' }
autocmd FileType fennel setlocal shiftwidth=2 tabstop=2
autocmd FileType go setlocal noexpandtab listchars=tab:\ \ ,trail:·
autocmd FileType haskell let g:AutoPairs = {'(':')',  '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType haskell setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType html.handlebars setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType markdown let g:AutoPairs = {}
autocmd FileType python map <localleader>e :!python %<cr>
autocmd FileType rust let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', '`':'`'}
autocmd FileType scheme let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"' }
autocmd FileType scheme setlocal shiftwidth=2 tabstop=2
autocmd FileType sh setlocal fo-=t
autocmd FileType svg setlocal shiftwidth=2 tabstop=2

augroup global_todo
    au!
    au Syntax * syn match GlobalTodo /\v\C<(FIXME|NOTE|TODO|XXX)/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link GlobalTodo Todo

let g:ale_set_signs = 0
let g:ale_linters = {'clojure': ['clj-kondo']}
let g:ale_fixers = {'javascript': ['deno'], 'python': ['black']}
let g:ale_python_black_options = '--line-length 80'
let g:ale_fix_on_save = 1
let g:conjure#log#hud#enabled = v:false
let g:fzf_layout = { 'down': '~16' }
let g:go_fmt_command = "goimports"
let g:rustfmt_autosave = 1
let g:sexp_enable_insert_mode_mappings = 0
let g:sexp_filetypes = 'clojure,scheme,lisp,timl,fennel'

let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1
let g:fennel_align_multiline_strings = 1
let g:fennel_align_subforms = 1

" adapted from https://github.com/junegunn/fzf.vim/blob/2bf85d25e203a536edb2c072c0d41b29e8e4cc1b/plugin/fzf.vim#L60
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --colors 'path:none' --colors 'line:none' --smart-case -- ".shellescape(<q-args>), 1, {}, <bang>0)

" keymaps
let mapleader=" "
let maplocalleader=" l"

inoremap <m-bs> <c-w>

nmap <leader>r <localleader>ls:res 18<cr><c-w>k
nmap <leader>c <localleader>lq

nnoremap / /\v
nnoremap ? ?\v
nnoremap <down> 9<down>
nnoremap <esc> :noh<cr><esc>
nnoremap <leader> <nop>
nnoremap <leader><tab> <c-w>w
nnoremap <leader>N :bp<cr>
nnoremap <leader>O O<esc>O
nnoremap <leader>aj :ALENextWrap<cr>
nnoremap <leader>ak :ALEPreviousWrap<cr>
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>d /<<<<<<<\\|=======\\|\|\|\|\|\|\|\|\\|>>>>>>><cr>
nnoremap <leader>e :Files<cr>
nnoremap <leader>f :Rg<cr>
nnoremap <leader>hq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
nnoremap <leader>j *N
nnoremap <leader>k "_
nnoremap <leader>m :res 99<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>o o<esc>O
nnoremap <leader>q :qa!<cr>
nnoremap <leader>s :w<cr>
nnoremap <leader>t <nop>
nnoremap <leader>t2 :set shiftwidth=2<cr>:set tabstop=2<cr>
nnoremap <leader>t4 :set shiftwidth=4<cr>:set tabstop=4<cr>
nnoremap <leader>te :set expandtab<cr>
nnoremap <leader>tn :set noexpandtab<cr>
nnoremap <leader>v <c-v>
nnoremap <leader>w :bd<cr>
nnoremap <left> ^
nnoremap <right> $
nnoremap <up> 9<up>
nnoremap U <c-r>
nnoremap x "_x

vnoremap <up> 9<up>
vnoremap <down> 9<down>
vnoremap <left> ^
vnoremap <right> $
vnoremap x "_x

" search for selected text
vnoremap <silent> <leader>j :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<cr>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gV:call setreg('"', old_reg, old_regtype)<cr>N
