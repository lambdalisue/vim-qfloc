function! qfloc#edit#cundo() abort
  let hist = get(w:, 'qfloc_qf_history', [])
  if !empty(hist)
    call setqflist(remove(hist, -1), 'r')
  endif
endfunction

function! qfloc#edit#lundo() abort
  let hist = get(w:, 'qfloc_loc_history', [])
  if !empty(hist)
    call setloclist(0, remove(hist, -1), 'r')
  endif
endfunction

function! qfloc#edit#cdelete() abort range
  let list = getqflist()
  let w:qfloc_qf_history = get(w:, 'qfloc_qf_history', [])
  call add(w:qfloc_qf_history, copy(list))
  unlet! list[a:firstline - 1 : a:lastline - 1]
  call setqflist(list, 'r')
  execute a:firstline
endfunction

function! qfloc#edit#ldelete() abort range
  let list = getloclist(0)
  let w:qfloc_loc_history = get(w:, 'qfloc_loc_history', [])
  call add(w:qfloc_loc_history, copy(list))
  unlet! list[a:firstline - 1 : a:lastline - 1]
  call setloclist(0, list, 'r')
  execute a:firstline
endfunction
