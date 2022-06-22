" ================================
" ### Auto Install vim-plugins ###
" ================================
if empty(glob('~/.config/nvim/autoload/plug.vim'))

silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

endif




" ======================
" ### BASIC SETTINGS ###
" ======================

set nocompatible
set wildmenu

syntax enable

set encoding=utf-8
set hidden


" === Display ===
set number
set cursorline
set mouse=a 

set wrap
set showcmd



" === Search ===
set hlsearch
exec "nohlsearch"
set smartcase
set ignorecase



" === Edit ===
set autoindent
set tabstop=4
set shiftwidth=4



" === Window ===
" Split
map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sk :set nosplitbelow<CR>:split<CR>
map sj :set splitbelow<CR>:split<CR>

" Switch tabs
map tn :tabe<CR>
map tl :+tabnext<CR>
map th :-tabnext<CR>

" Switch windows
map wh <C-w>h
map wj <C-w>j
map wk <C-w>k
map wl <C-w>l




" =======================
" ### ADVANCED TRICKS ###
" =======================

" enable built-in plugins
filetype plugin on



" === FILES FINDING ===
" find files in the root directory and all its sub-directories recursively
set path+=**



" === TAGS ===
" create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .
" - ^]		to jump to tag under cursor
" - g^]		for ambiuous tags
" - ^t 		to jump back up the tags stack



" === AUTOCOMPLETE ===
" - ^n 		for anything specified by the 'complete' option
" - ^x^n	for JUST the current file
" - ^x^f	for filenames (works with the path variable set up before)
" - ^x^]	for tags only
"
" - ^n go to the next; ^p go to the previous




" =================
" ### FUNCTIONS ###
" =================

noremap <C-l> :call CompileAndRun()<CR>
func! CompileAndRun()
	exec "w"
	if &filetype == 'c'
		set splitbelow
		:sp
		:term gcc -std=c11 -Wall -o %:r %:r.c && ./%:r
	elseif &filetype == 'java'
		set splitbelow
		:sp
		:term javac %:r.java && java %:r
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %:r.py
	elseif &filetype == 'pdf'
		:!qlmanage -p %:r.pdf
	elseif &filetype == 'tex'
		:!pdflatex %:r && qlmanage -p %:r.pdf
		":!pdflatex %:r && evince %:r.pdf<CR><CR>
	endif
endfunc


func! CatCurrentFile()
	exec "w"
	set splitbelow
	:sp
	:term cat %
endfunction




" ===============
" ### PLUGINS ###
" ===============
call plug#begin('~/.config/nvim/plugged')

" Status bar
Plug 'vim-airline/vim-airline'

" Color Scheme
Plug 'cateduo/vsdark.nvim' 
Plug 'cocopon/iceberg.vim'

" File manager
Plug 'preservim/nerdtree'

" Auto completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'

call plug#end()



" === colorscheme ===
" ### vsdark
"set termguicolors
"let g:vsdark_style = "dark"
"colorscheme vsdark

" ### iceberg
colorscheme iceberg



" === NERDTree ===
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif



" === coc.nvim ===
let g:coc_global_extensions = [
		\ 'coc-marketplace', 
		\ 'coc-vimlsp', 
		\ 'coc-json',
		\ 'coc-html',
		\ 'coc-css',
		\ 'coc-java', 
		\ 'coc-pyright',  
		\ 'coc-clangd',
		\ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

