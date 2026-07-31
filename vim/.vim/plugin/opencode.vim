" Find the root of the current Git repository
function! GetRepoRoot()
    let l:root = system('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --show-toplevel 2>/dev/null')
    let l:root = substitute(l:root, '\n$', '', '')
    if empty(l:root)
        return getcwd()
    endif
    return l:root
endfunction

" Send selection or cursor location to OpenCode in Plan Mode
function! OpenCodePrompt(prompt_prefix) range
    let l:repo_root = GetRepoRoot()
    let l:abs_filepath = expand('%:p')

    " Make path relative to repo root if inside repo root, otherwise fall back to full path
    if l:abs_filepath =~ '^' . escape(l:repo_root, '/\')
        let l:rel_filepath = simplify(strpart(l:abs_filepath, strlen(l:repo_root) + 1))
    else
        let l:rel_filepath = l:abs_filepath
    endif

    " Determine if invoked via Visual Mode range or Normal Mode position
    if a:firstline == a:lastline && mode() !=# 'v' && mode() !=# 'V' && mode() !=# "\<C-V>"
        " --- Normal Mode: Single line/cursor location ---
        let l:location = l:rel_filepath . ":" . line('.') . ":" . col('.')
    else
        " --- Visual Mode: Exact start and end bounds ---
        let l:start_line = a:firstline
        let l:start_col = col("'<")
        let l:end_line = a:lastline
        let l:end_col = col("'>")
        let l:location = l:rel_filepath . ":" . l:start_line . ":" . l:start_col . "-" . l:end_line . ":" . l:end_col
    endif

    " Build full prompt
    let l:initial_prompt = a:prompt_prefix . " | Context: " . l:location

    " cd into repo_root first so opencode starts in project directory without needing --dir
    let l:cmd = 'vertical rightbelow terminal opencode ' . l:repo_root . ' --agent plan --prompt "' . l:initial_prompt . '"'

    echom l:cmd
    execute l:cmd
endfunction

" Normal Mode Mappings (uses current cursor position)
command! -range Explain :call OpenCodePrompt("Explain this code step-by-step")<CR>
command! -range Comment :call OpenCodePrompt("Add inline documentation and comments")<CR>
command! -range Ask     :call OpenCodePrompt("How can I improve this?")<CR>
