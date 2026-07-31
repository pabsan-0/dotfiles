" TODO aglomerate all commands in a fzf wrapper

" look for # vimcmd: in the first lines and execute it
function! VimCmdExecute()
    " default command
    let command = "%:p"

    let line = 1
    while line <= 5 && line('$') >= line
        let comment = getline(line)
        if comment =~ 'vimcmd:\s*\S\+'
            let command = substitute(comment, '.*vimcmd:\s*\(\S\+.*\)$', '\1', '')
            break
        endif
        let line += 1
    endwhile
    execute "!".command
    "normal ":!".command
endfunction
