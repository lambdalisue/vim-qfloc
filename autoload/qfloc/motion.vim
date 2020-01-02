function! qfloc#motion#cmove(motion) abort
  return s:move(getqflist(), a:motion)
endfunction

function! qfloc#motion#lmove(motion) abort
  return s:move(getloclist(0), a:motion)
endfunction

function! s:move(list, motion) abort
  let m = line('$')
  let c = line('.') - 1
  let n = s:norm(c, a:motion, m)
  let o = 0 < a:motion ? 1 : -1
  while c != n && a:list[n].bufnr is# 0
    let n = s:norm(n, o, m)
  endwhile
  return (v:count ==# 0 ? '' : "\<Esc>") . (n + 1) . 'G'
endfunction

function! s:norm(n, o, m) abort
  let v = a:n + a:o
  if g:qfloc#motion#wrap
    return ((v % a:m) + a:m) % a:m
  else
    return v < 0 ? 0 : v >= a:m ? a:n : v
  endif
endfunction

let g:qfloc#motion#wrap = get(g:, 'qfloc#motion#wrap', 1)
