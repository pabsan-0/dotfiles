function! UECppSwitch()
    " Switch between header and source in UE cpp file structures

    let l:extension = expand('%:e')
    let l:filename_noext = expand('%:p:r')

    " Source file in case-insensitive Private directory
    if l:extension == 'cpp' && l:filename_noext =~ '/private/'

        " Append extension and case-preserving substitution
        let l:filename = l:filename_noext .. '.h'
        if l:filename_noext =~# '/private/'
            let l:filename = substitute (l:filename, '/\Cprivate/', '/public/', 'gi')
        else
            let l:filename = substitute (l:filename, '/\CPrivate/', '/Public/', 'gi')
        endif

        execute "edit " ..  expand(l:filename)

    " Header file in case-insensitive Public directory
    elseif l:extension == 'h' && l:filename_noext =~ '/public/'

        " Append extension and case-preserving substitution
        let l:filename = l:filename_noext .. '.cpp'
        if l:filename_noext =~# '/public/'
            let l:filename = substitute (l:filename, '/\Cpublic/', '/private/', 'gi')
        else
            let l:filename = substitute (l:filename, '/\CPublic/', '/Private/', 'gi')
        endif

        execute "edit " ..  expand(l:filename)
    endif
endfunction

" nnoremap <silent> <leader><leader>c :call UECppSwitch()<CR>
