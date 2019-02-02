function! qfloc#message#info(message, ...) abort
  let message = a:0 ? call("printf", [a:message] + a:000) : a:message
  redraw | echo '[qfloc] ' . message
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
