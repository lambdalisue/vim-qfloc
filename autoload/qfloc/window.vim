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
