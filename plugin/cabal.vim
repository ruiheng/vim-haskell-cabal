" Vim global plugin for Cabal
" Last Change:  2010 November 02
" Name:         Cabal
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" License:      This plugin is licensed under the BSD3 license.

if exists("loaded_cabal")
  finish
endif
let loaded_cabal = 1

let cpoOriginal = &cpo
set cpo&vim

augroup cabalPlugin
  autocmd!
  autocmd QuickfixCmdPost make* call cabal#ConvertErrorMessages()
  autocmd BufNewFile,BufRead Gemfile call cabal#SetupBufCommands()
  autocmd BufEnter * call <SID>EnableCabalPlugin()
augroup END

function s:EnableCabalPlugin()
  let cabalCfgPath = glob("*.cabal", getcwd())
  if filereadable(cabalCfgPath)
    call cabal#SetupBufCommands()
    silent doautocmd cabalPlugin
    " TODO: Add subcommand variable population
    call cabal#SetupSubcommands()
  endif
endfunction

call s:EnableCabalPlugin()

" Default key map
if !hasmapto('<Plug>Cabal')
    map <unique> <Leader>C <Plug>Cabal
endif

let &cpo = cpoOriginal
unlet cpoOriginal
