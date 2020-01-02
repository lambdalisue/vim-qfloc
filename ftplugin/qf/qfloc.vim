if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1
let s:is_loclist = getwininfo(win_getid())[0].loclist

if s:is_loclist
  nnoremap <silent><buffer><expr> <Plug>(qfloc-j) qfloc#motion#lmove(v:count1)
  nnoremap <silent><buffer><expr> <Plug>(qfloc-k) qfloc#motion#lmove(-v:count1)
  nnoremap <silent><buffer> <Plug>(qfloc-sbuffer) :<C-u>call qfloc#window#lsbuffer()<CR>
  nnoremap <silent><buffer> <Plug>(qfloc-undo) :<C-u>call qfloc#edit#lundo()<CR>
  nnoremap <silent><buffer> <Plug>(qfloc-delete) :call qfloc#edit#ldelete()<CR>
  xnoremap <silent><buffer> <Plug>(qfloc-delete) :call qfloc#edit#ldelete()<CR>
else
  nnoremap <silent><buffer><expr> <Plug>(qfloc-j) qfloc#motion#cmove(v:count1)
  nnoremap <silent><buffer><expr> <Plug>(qfloc-k) qfloc#motion#cmove(-v:count1)
  nnoremap <silent><buffer> <Plug>(qfloc-sbuffer) :<C-u>call qfloc#window#csbuffer()<CR>
  nnoremap <silent><buffer> <Plug>(qfloc-undo) :<C-u>call qfloc#edit#cundo()<CR>
  nnoremap <silent><buffer> <Plug>(qfloc-delete) :call qfloc#edit#cdelete()<CR>
  xnoremap <silent><buffer> <Plug>(qfloc-delete) :call qfloc#edit#cdelete()<CR>
endif
nnoremap <silent><buffer> <Plug>(qfloc-preview) <CR>zz<C-w>p

if !get(g:, 'qfloc_disable_default_mappings')
  nmap <buffer> j <Plug>(qfloc-j)
  nmap <buffer> k <Plug>(qfloc-k)
  nmap <buffer> s <Plug>(qfloc-sbuffer)
  nmap <buffer> p <Plug>(qfloc-preview)
  nmap <buffer> u <Plug>(qfloc-undo)
  nmap <buffer> dd <Plug>(qfloc-delete)
  xmap <buffer> d  <Plug>(qfloc-delete)
endif
