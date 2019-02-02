if exists('g:loaded_qfloc')
  finish
endif
let g:loaded_qfloc = 1

nnoremap <silent> <Plug>(qfloc-cswitch) :<C-u>call qfloc#window#cswitch()<CR>
nnoremap <silent> <Plug>(qfloc-lswitch) :<C-u>call qfloc#window#lswitch()<CR>
nnoremap <silent> <Plug>(qfloc-cnext) :<C-u>call qfloc#jump#cnext()<CR>
nnoremap <silent> <Plug>(qfloc-cprevious) :<C-u>call qfloc#jump#cprevious()<CR>
nnoremap <silent> <Plug>(qfloc-lnext) :<C-u>call qfloc#jump#lnext()<CR>
nnoremap <silent> <Plug>(qfloc-lprevious) :<C-u>call qfloc#jump#lprevious()<CR>

if !get(g:, 'qfloc_disable_default_mappings')
  nmap Q <Plug>(qfloc-cswitch)
  nmap L <Plug>(qfloc-lswitch)
  nmap <expr> ]c &diff ? ']c' : "\<Plug>(qfloc-cnext)"
  nmap <expr> [c &diff ? '[c' : "\<Plug>(qfloc-cprevious)"
  nmap ]l <Plug>(qfloc-lnext)
  nmap [l <Plug>(qfloc-lprevious)
endif

if !get(g:, 'qfloc_disable_sign')
  call qfloc#document#sign#enable()
endif

if !get(g:, 'qfloc_disable_hover')
  call qfloc#document#hover#enable()
endif
