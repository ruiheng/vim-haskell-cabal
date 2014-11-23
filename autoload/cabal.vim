" Vim Cabal autoload
" Name:		      Cabal
" Maintainer:   Susan Potter <me [at] susanpotter [dot] net>
" Last Change:  02 Nov 2011

" Public functions

" Retrieve error format for a specific subcommand
function cabal#ErrorFormatFor(subCmd)
  let subCmd = a:subCmd
  let errorFormats = {}
  let errorFormats['build']="%f:%l:%c: Warning:,%f:%l:%c:,%f:%l:%c: %m"

  for cmd in g:cabalSubcommands
    if !has_key(errorFormats, cmd)
      let errorFormats[cmd] = ""
    endif
  endfor

  return errorFormats[subCmd]
endfunction

" Execute the cabal command
function cabal#Execute(subCmd)
  let subCmd = a:subCmd
  let makeprgOriginal = &l:makeprg
  let errorformatOriginal = &l:errorformat
  try
    let &l:makeprg = 'cabal'
    let &l:errorformat = cabal#ErrorFormatFor(subCmd)
    exec 'make '.subCmd
    copen
  catch /^Vim(\a\+):E42:/
    " do nothing, because there are no errors...maybe output SUCCESS or
    " something?
    echohl '":Cabal '.subCmd.'" completed without errors'
  finally
    let &l:errorformat = errorformatOriginal
    let &l:makeprg = makeprgOriginal
  endtry
endfunction

" Converts error message format to something more readable
function cabal#ConvertErrorMessages()
  if &l:makeprg =~ 'cabal'
    let quickfixList = getqflist()
    " Only show valid quickfix lines in output
    "call filter(quickfixList, 'v:val.valid')
    " filter to remove unnecessary quickfix line output
    call filter(quickfixList, 'v:val.text !~ "Loading package "')
    call setqflist(quickfixList)
  endif
endfunction

" Auto-complete all available subcommands for cabal
function cabal#AutoCompleteSubcommands(ArgLead, CmdLine, CursorPos)
  let matches = copy(g:cabalSubcommands)
  let condition = 'v:val =~ "^' . a:ArgLead . '"'
  call filter(matches, condition)
  return matches
endfunction

function cabal#SetupSubcommands()
  if !exists('g:cabalSubcommands')
    try
      let lines = split(system("cabal --help"), "\n")
    endtry
    if v:shell_error != 0
      return []
    endif
    call map(lines, 'matchstr(v:val, "[a-zA-Z0-9-]*")')
    call filter(lines, 'v:val != ""')
    let g:cabalSubcommands = lines
  endif
endfunction

" Setup buffer commands
function cabal#SetupBufCommands()
  command! -buffer -nargs=1 -complete=customlist,cabal#AutoCompleteSubcommands Cabal call cabal#Execute(<q-args>)
endfunction

" vim: ft=vim
