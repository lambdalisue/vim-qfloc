function! qfloc#message#info(message, ...) abort
  let message = a:0 ? call('printf', [a:message] + a:000) : a:message
  let message = s:shrink('[qfloc] ' . message)
  redraw | echo message
endfunction

function! qfloc#message#warn(message, ...) abort
  echohl Title
  call call('qfloc#message#info', [a:message] + a:000)
  echohl None
endfunction

function! qfloc#message#error(message, ...) abort
  echohl WarningMsg
  call call('qfloc#message#info', [a:message] + a:000)
  echohl None
endfunction

function! qfloc#message#exception() abort
  call qfloc#message#error(substitute(v:exception, '^Vim(.*):', '', ''))
endfunction

function! s:shrink(message) abort
  let m = join(map(
        \ split(a:message, '\n'),
        \ { -> substitute(v:val, '\%(^\s\+\|\s\+$\)', '', 'g') },
        \))
  let w = winwidth(0) - 1
  if strwidth(m) <= w
    return m
  endif
  let w -= 3
  let s = w
  while strwidth(m) > w
    let m = strcharpart(m, 0, s)
    let s -= 1
  endwhile
  return m . '...'
endfunction
