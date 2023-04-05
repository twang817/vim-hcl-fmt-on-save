if exists('b:did_ftplugin') || v:version < 700 || &compatible
  finish
endif

if !exists('g:terraform_binary_path')
  let g:terraform_binary_path='terraform'
endif

if !executable(g:terraform_binary_path)
  finish
endif

if get(g:, 'hcl_fmt_on_save', 1)
  augroup vim.terragrunt.fmt
    autocmd!
    autocmd BufWritePre *.hcl call terraform#fmt()
  augroup END
endif
