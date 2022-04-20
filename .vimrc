"set tabstop=4 softtabstop=4
"set shiftwidth=4
"set smartindent
set nu
set relativenumber
set nohlsearch
set nowrap
set smartcase

set noswapfile
"set nobackup
"set undodir=~/.vim/undodir
"set undofile

set noet ci pi sts=0 sw=4 ts=4

set incsearch
set scrolloff=8
set path+=**
set complete-=i
set wildmenu
let &t_EI = "\<Esc>[2 q"

vnoremap <SPACE>j <C-v>I#<Esc>
vnoremap <SPACE>k <C-v>d<Esc>
nnoremap <SPACE>r diw"0P
nnoremap <SPACE>c *Ncgn
nnoremap <SPACE>t :%s/    /\t/gc
nnoremap <SPACE>l :set list<cr>
nnoremap <SPACE>L :set nolist<cr>
nnoremap <SPACE>w :set wrap<cr>
nnoremap <SPACE>W :set nowrap<cr>
nnoremap <SPACE>h :set hls<cr>
nnoremap <SPACE>H :set nohls<cr>
nnoremap <SPACE>a :set noet ci pi sts=0 sw=4 ts=4<cr>
nnoremap <SPACE>o :Vexplore<cr>
xnoremap <SPACE>( xi()<Esc>P
xnoremap <SPACE>[ xi[]<Esc>P
xnoremap <SPACE>{ xi{}<Esc>P
xnoremap <SPACE>' xi''<Esc>P
xnoremap <SPACE>" xi""<Esc>P
nnoremap <SPACE>* I/*<Esc>A*/<Esc>j
nnoremap <SPACE>/ ^xx<Esc>$xx<Esc>j

set termguicolors
colorscheme desert
highlight Comment cterm=bold
highlight Pmenu ctermbg=gray guibg=gray
syntax on

au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>

function! NetrwOpenMultiTab(current_line,...) range
   " Get the number of lines.
   let n_lines =  a:lastline - a:firstline + 1

   " This is the command to be built up.
   let command = "normal "

   " Iterator.
   let i = 1

   " Virtually iterate over each line and build the command.
   while i < n_lines
      let command .= "tgT:" . ( a:firstline + i ) . "\<CR>:+tabmove\<CR>"
      let i += 1
   endwhile
   let command .= "tgT"

   " Restore the Explore tab position.
   if i != 1
      let command .= ":tabmove -" . ( n_lines - 1 ) . "\<CR>"
   endif

   " Restore the previous cursor line.
   let command .= ":" . a:current_line  . "\<CR>"

   " Check function arguments
   if a:0 > 0
      if a:1 > 0 && a:1 <= n_lines
         " The current tab is for the nth file.
         let command .= ( tabpagenr() + a:1 ) . "gt"
      else
         " The current tab is for the last selected file.
         let command .= (tabpagenr() + n_lines) . "gt"
      endif
   endif
   " The current tab is for the Explore tab by default.

   " Execute the custom command.
   execute command
endfunction

" Define mappings.
augroup NetrwOpenMultiTabGroup
   autocmd!
   autocmd Filetype netrw vnoremap <buffer> <silent> <expr> t ":call NetrwOpenMultiTab(" . line(".") . "," . "v:count)\<CR>"
   autocmd Filetype netrw vnoremap <buffer> <silent> <expr> T ":call NetrwOpenMultiTab(" . line(".") . "," . (( v:count == 0) ? '' : v:count) . ")\<CR>"
augroup END

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

function! MyFoldText()
    let nl = v:foldend - v:foldstart + 1
    let comment = substitute(getline(v:foldstart),"^ *","",1)
    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
    let txt = '+ ' . linetext . ' : "' . comment . '" : length ' . nl
    return txt
endfunction
set foldtext=MyFoldText()

