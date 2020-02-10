let s:timer = v:null
function! qfloc#document#enable() abort
  augroup qfloc_document_internal
    autocmd! *
    autocmd WinEnter     * call s:update_delay(bufnr('%'))
    autocmd TextChanged  * call s:update_delay(bufnr('%'))
    autocmd TextChangedI * call s:update_delay(bufnr('%'))
    autocmd BufReadPost  * call s:update_delay(bufnr('%'))
    autocmd BufWritePost * call s:update_delay(bufnr('%'))
    autocmd User QflocDocumentUpdated :
  augroup END
  silent! call timer_stop(s:timer)
  let s:timer = timer_start(
        \ g:qfloc#document#update_interval,
        \ { -> s:update(bufnr('%')) },
        \ { 'repeat': -1 },
        \)
  call s:update(bufnr('%'))
endfunction

function! qfloc#document#disable() abort
  augroup qfloc_document_internal
    autocmd! *
  augroup END
  silent! call timer_stop(s:timer)
  let s:timer = v:null
endfunction

function! qfloc#document#update(...) abort
  call s:update_delay(a:0 ? a:1 : bufnr('%'))
endfunction

function! qfloc#document#get(...) abort
  let bufnr = a:0 ? a:1 : bufnr('%')
  if empty(getbufvar(bufnr, 'qfloc_document'))
    call s:update(bufnr)
  endif
  return getbufvar(bufnr, 'qfloc_document', v:null)
endfunction

function! s:update(bufnr) abort
  if v:dying
        \ || bufwinnr(a:bufnr) is# -1
        \ || getbufvar(a:bufnr, '&buftype') =~# '^\%(help\|quickfix\|terminal\)$'
    return
  endif
  let list = []
  call extend(list, filter(getqflist(), { -> v:val.bufnr is# a:bufnr }))
  call extend(list, filter(getloclist(bufwinnr(a:bufnr)), { -> v:val.bufnr is# a:bufnr }))
  call s:update_document(a:bufnr, list[: g:qfloc#document#threshold])
endfunction

function! s:update_delay(bufnr) abort
  silent! call timer_stop(getbufvar(a:bufnr, 'qfloc_document_update_delay_timer'))
  call setbufvar(a:bufnr, 'qfloc_document_update_delay_timer', timer_start(
        \ g:qfloc#document#update_delay,
        \ { -> s:update(a:bufnr) },
        \))
endfunction

function! s:create_document(bufnr, list) abort
  let m = {}
  call map(a:list, { _, v -> extend(m, {
        \ (v.lnum . ''): extend(get(m, v.lnum . '', []), [v])
        \})})
  return {
        \ 'hash': sha256(string(a:list)),
        \ 'map': m,
        \}
endfunction

function! s:update_document(bufnr, list) abort
  let doc = getbufvar(a:bufnr, 'qfloc_document')
  if !empty(doc) && doc.hash ==# sha256(string(a:list))
    return
  endif
  call setbufvar(a:bufnr, 'qfloc_document', s:create_document(a:bufnr, a:list))
  doautocmd User QflocDocumentUpdated
endfunction

let g:qfloc#document#update_delay = 50
let g:qfloc#document#update_interval = 500
let g:qfloc#document#threshold = 100
