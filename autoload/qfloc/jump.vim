function! qfloc#jump#cnext() abort
  call s:jump('cc', 'cnext', 'cfirst')
endfunction

function! qfloc#jump#cprevious() abort
  call s:jump('cc', 'cprevious', 'clast')
endfunction

function! qfloc#jump#lnext() abort
  call s:jump('ll', 'lnext', 'lfirst')
endfunction

function! qfloc#jump#lprevious() abort
  call s:jump('ll', 'lprevious', 'llast')
endfunction

function! s:jump(init_expr, jump_expr, wrap_expr) abort
  try
    let c = getcurpos()
    execute a:init_expr
    if c != getcurpos()
      return
    endif
    execute a:jump_expr
  catch /^Vim\%((\a\+)\)\=:E553/
    if g:qfloc#jump#wrap
      execute a:wrap_expr
    else
      call qfloc#message#exception()
    endif
  catch /^Vim\%((\a\+)\)\=:E42/
    call qfloc#message#exception()
  endtry
endfunction

function! qfloc#jump#lsbuffer() abort
  call s:sbuffer(1)
endfunction

function! qfloc#jump#csbuffer() abort
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

let g:qfloc#jump#wrap = get(g:, 'qfloc#jump#wrap', 1)
