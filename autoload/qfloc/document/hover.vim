function! qfloc#document#hover#enable() abort
  augroup qfloc_document_hover_internal
    autocmd! *
    autocmd CursorMoved * call qfloc#document#hover#echo()
  augroup END
  call qfloc#document#enable()
endfunction

function! qfloc#document#hover#disable() abort
  augroup qfloc_document_hover_internal
    autocmd! *
  augroup END
endfunction

function! qfloc#document#hover#echo(...) abort
  let doc = call('qfloc#document#get', a:000)
  if empty(doc)
    return
  endif
  let item = get(get(doc.map, line('.') . '', []), 0)
  if empty(item)
    redraw | echo ''
  elseif item.type ==# 'E'
    redraw | call qfloc#message#error(item.text)
  elseif item.type ==# 'W'
    redraw | call qfloc#message#warn(item.text)
  else
    redraw | call qfloc#message#info(item.text)
  endif
endfunction
