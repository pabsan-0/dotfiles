augroup MesonNinjaBuild
    autocmd!
    autocmd BufRead,BufNewFile * call s:SetMesonMakeprg()
augroup END

function! s:SetMesonMakeprg()
    let l:meson_file = findfile('meson.build', '.;')
    if !empty(l:meson_file)
        let l:repo_root = fnamemodify(l:meson_file, ':p:h')
        compiler gcc
        let &l:makeprg = 'ninja -C build'
        let &l:errorformat = '%-Gninja: %.%#,%-G[%*[0-9]/%*[0-9]] %.%#,' . &l:errorformat
    endif
endfunction
