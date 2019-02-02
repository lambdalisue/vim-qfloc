function! qfloc#document#sign#enable() abort
  augroup qfloc_document_sign_internal
    autocmd! *
    autocmd User QflocDocumentUpdated call s:update(bufnr('%'))
  augroup END
  call qfloc#document#enable()
endfunction

function! qfloc#document#sign#disable() abort
  augroup qfloc_document_sign_internal
    autocmd! *
  augroup END
endfunction

function! qfloc#document#sign#update(...) abort
  call s:update(a:0 ? a:1 : bufnr('%'))
endfunction

function! s:update(bufnr) abort
  if v:dying
        \ || bufwinnr(a:bufnr) is# -1
        \ || getbufvar(a:bufnr, '&buftype') =~# '^\%(help\|quickfix\|terminal\)$'
    return
  endif
  let doc = qfloc#document#get(a:bufnr)
  if empty(doc)
    return
  endif
  let exprs = []
  let signs = s:list_signs(printf('sign place buffer=%d', a:bufnr))
  call extend(exprs, map(signs, { _, v -> printf(
        \ 'sign unplace %d buffer=%d',
        \ v.id,
        \ a:bufnr,
        \)}))
  let items = map(
        \ values(doc.map)[:(g:qfloc#document#sign#threshold - 1)],
        \ { -> v:val[0] },
        \)
  call extend(exprs, map(items, { k, v -> printf(
        \ 'sign place %d line=%d name=%s buffer=%d',
        \ g:qfloc#document#sign#id_offset + k,
        \ v.lnum,
        \ s:get_sign_name(v.type),
        \ a:bufnr,
        \)}))
  for expr in exprs
    execute expr
  endfor
endfunction

function! s:list_signs(expr) abort
  let signs = filter(split(execute(a:expr), '\n'), { -> v:val[:3] ==# '    ' })
  let signs = map(signs, { -> s:parse_sign(v:val) })
  return filter(signs, { -> v:val.name[:8] ==# 'QflocSign' })
endfunction

function! s:parse_sign(sign) abort
  let ts = split(a:sign)
  return {
        \ 'line': split(ts[0], '=')[1],
        \ 'id': split(ts[1], '=')[1],
        \ 'name': split(ts[2], '=')[1],
        \}
endfunction

function! s:get_sign_name(type) abort
  if a:type ==# 'E'
    return 'QflocSignError'
  elseif a:type ==# 'W'
    return 'QflocSignWarning'
  else
    return 'QflocSignInfo'
  endif
endfunction

function! s:define_highlight() abort
  highlight default link QflocSignErrorLine None
  highlight default link QflocSignErrorText DiffDelete
  highlight default link QflocSignWarningLine None
  highlight default link QflocSignWarningText DiffChange
  highlight default link QflocSignInfoLine QflocSignWarningLine
  highlight default link QflocSignInfoText QflocSignWarningText
  augroup qfloc_document_sign_highlight_internal
    autocmd! *
    autocmd ColorScheme * call s:define_highlight()
  augroup END
endfunction

function! s:define_sign() abort
  sign define QflocSignError
        \ linehl=QflocSignErrorLine
        \ texthl=QflocSignErrorText
        \ text=>>
  sign define QflocSignWarning
        \ linehl=QflocSignWarningLine
        \ texthl=QflocSignWarningText
        \ text===
  sign define QflocSignInfo
        \ linehl=QflocSignInfoLine
        \ texthl=QflocSignInfoText
        \ text=--
  augroup qfloc_document_sign_sign_internal
    autocmd! *
    autocmd User QflocSignInit :
  augroup END
  doautocmd User QflocSignInit
endfunction

let g:qfloc#document#sign#id_offset = get(g:, 'qfloc#document#sign#id_offset', 10000)
let g:qfloc#document#sign#threshold = get(g:, 'qfloc#document#sign#threshold', 100)
let g:qfloc#document#sign#update_delay = get(g:, 'qfloc#document#sign#update_delay', 30)
let g:qfloc#document#sign#update_timer = get(g:, 'qfloc#document#sign#update_timer', 1000)

call s:define_highlight()
call s:define_sign()
