function! terraform#fmt() abort
  silent execute 'w !'.g:terraform_binary_path.' fmt -check -'
  if v:shell_error == 0
    return
  endif

  " Save the view.
  let curw = winsaveview()

  " Make a fake change so that the undo point is right.
  normal! ix
  normal! "_x

  " Execute `terraform fmt`, redirecting stderr to a temporary file.
  let tmpfile = tempname()
  let shellredir_save = &shellredir
  let &shellredir = '>%s 2>'.tmpfile
  silent execute '%!'.g:terraform_binary_path.' fmt -no-color -'
  let &shellredir = shellredir_save

  " If there was an error, undo any changes and show stderr.
  if v:shell_error != 0
    silent undo
    let output = readfile(tmpfile)
    echo join(output, "\n")
  endif

  " Delete the temporary file, and restore the view.
  call delete(tmpfile)
  call winrestview(curw)
endfunction
