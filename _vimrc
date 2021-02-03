" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/vimfiles/plugged')

" Make sure you use single quotes

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'mhinz/vim-startify'
Plug 'Valloric/YouCompleteMe'
Plug 'gmarik/Vundle.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'majutsushi/tagbar'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'airblade/vim-gitgutter' " vim with git status(added, modified, and removed lines)
Plug 'tpope/vim-fugitive' " vim with git command(e.g., Gdiff)
Plug 'vim-airline/vim-airline' " vim status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'blueyed/vim-diminactive'
Plug 'scrooloose/nerdtree'

" Initialize plugin system
call plug#end()

set t_Co=256

set fenc=utf-8
set fencs=utf-8,cp949,euc-kr
set encoding=cp949
set langmenu=cp949

"vimwiki 설정

let g:vimwiki_list = [
            \{
            \   'path': 'C:\Users\한도형\Desktop\bodyrock13.github.io\_wiki',
            \   'ext' : '.md',
            \   'diary_rel_path': '.',
            \},
            \{
            \   'path': 'C:\Users\한도형\Desktop\wiki_local',
            \   'ext' : '.md',
            \   'diary_rel_path': '.',
            \}
            \]
let g:vimwiki_conceallevel = 0
let g:vimwiki_table_mappings = 0

command! WikiIndex :VimwikiIndex
nmap <LocalLeader>ww <Plug>VimwikiIndex
" nmap <LocalLeader>wt <Plug>VimwikiTabIndex
nmap <LocalLeader>ws <Plug>VimwikiUISelect
nmap <LocalLeader>wi <Plug>VimwikiDiaryIndex
nmap <LocalLeader>w<LocalLeader>w <Plug>VimwikiMakeDiaryNote
nmap <LocalLeader>w<LocalLeader>t <Plug>VimwikiTabMakeDiaryNote
nmap <LocalLeader>w<LocalLeader>y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <LocalLeader>wh <Plug>Vimwiki2HTML
nmap <LocalLeader>whh <Plug>Vimwiki2HTMLBrowse
nmap <LocalLeader>wt :VimwikiTable<CR>

nmap <Tab>d 0f]lli__date<Space><esc>

" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])

        exe 'keepjumps 1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
                    \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun
function! NewTemplate()

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') == expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tag     : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction
augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md keepjumps call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
    autocmd FileType vimwiki inoremap <S-Right> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    autocmd FileType vimwiki inoremap <S-Left> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
augroup END

augroup vimwiki_tagbar
    " autocmd BufRead,BufNewFile *wiki/*.md TagbarOpen
    autocmd VimLeavePre *.md TagbarClose
augroup END

function! RefreshTagbar()
     let l:is_tagbar_open = bufwinnr('__Tagbar__') != -1
     if l:is_tagbar_open
         TagbarClose
         TagbarOpen
     endif
endfunction

function! UpdateBookProgress()
    let l:cmd = g:vim_wiki_set_path . "/bookProgressUpdate.sh " . expand('%:p')
    call system(l:cmd)
    edit
endfunction

augroup todoauto
    autocmd BufWritePost *wiki/book.md call UpdateBookProgress()
augroup END

let g:md_modify_disabled = 0

"여기까지 vimwiki



"nerdtree 단축키설정
nmap <f9> :NERDTRee<CR>

" 여기부터 복사한 것
" for jellybeans
colorscheme jellybeans

" for taglist
nmap <F8> :Tagbar<CR>

" for indent guide
let g:indentguides_spacechar = '??
let g:indentguides_tabchar = '|'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" for vim-airline
let g:airline#extensions#tabline#enabled = 1 " turn on buffer list
let g:airline_theme='hybrid'
set laststatus=2 " turn on bottom bar
let mapleader = ","
nnoremap <leader>q :bp<CR>
nnoremap <leader>w :bn<CR>

" for blueyed/vim-diminactive
let g:diminactive_enable_focus = 1

syntax enable
filetype indent on
highlight Comment term=bold cterm=bold ctermfg=4

set number


" 여기부터 원래 있던 거
" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

