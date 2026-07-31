function! OpenReadmeAtGitRoot()
    " Get the path to the repository root (empty on error)
    let root = system('git rev-parse --show-toplevel 2>/dev/null')

    " Check if root is empty (indicates error)
    if empty(root)
        echoerr "Not a git repository"
        return
    endif

    " Open README.md in a new buffer
    let root = root[0:-2]
    execute 'edit ' . root .'/README.md'
endfunction
