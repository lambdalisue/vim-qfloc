function! qfloc#window#cswitch() abort
  call s:switch('botright copen', 'cclose')
endfunction

function! qfloc#window#lswitch() abort
  call s:switch('lopen', 'lclose')
endfunction

function! s:switch(open_expr, close_expr) abort
  try
    let nwin = winnr('$')
    execute a:close_expr
    if nwin == winnr('$')
      execute a:open_expr
    endif
  catch /^Vim\%((\a\+)\)\=:E776/
    call qfloc#message#exception()
  endtry
endfunction

function! qfloc#window#lsbuffer() abort
  call s:sbuffer(1)
endfunction

function! qfloc#window#csbuffer() abort
  call s:sbuffer(0)
endfunction

function! s:sbuffer(is_loclist) abort
  if a:is_loclist
    let list = getloclist(winnr())
  else
    let list = getqflist()
  endif
  let item = get(list, line('.') - 1, {})
  let bufnr = get(item, 'bufnr', -1)
  if bufnr ==# -1
    call qfloc#message#error('could not get buffer number')
    return
  endif
  execute bufnr 'sbuffer'
  " Go to the lnum and col
  wincmd p
  execute "normal! \<CR>"
endfunction
