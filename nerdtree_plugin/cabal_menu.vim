" File:         cabal.vim
" Description:  A NERDTree plugin to execute the cabal project files inside Vim
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" Last Change:  2010-08-25
" Name:         cabal
" Version:      0.1
" License:      Charityware license


" Adds a submenu to the NERD tree menu if a cabal Gemfile exists in the root.
if exists("g:loaded_nerdtree_cabal_menu")
  finish
endif
let g:loaded_nerdtree_cabal_menu = 1

" {{{ Local functions
function s:cabalConfPath()
  let cabalConfPath = fnamemodify(b:NERDTreeRoot.path.str(), ":p") . "/cabal.config"
  return cabalConfPath
endfunction

function s:SetupCabalSubmenu()
  call NERDTreeAddMenuSeparator()
  let cabalSubmenu = NERDTreeAddSubmenu({
    \ 'text': 'Cabal commands',
    \ 'isActiveCallback': 'NERDTreeCabalMenuEnabled',
    \ 'shortcut': 'C' })
  call NERDTreeAddMenuItem({
    \ 'text': 'cabal (b)uild',
    \ 'shortcut': 'b',
    \ 'callback': 'NERDTreeCabalBuild',
    \ 'parent': l:cabalSubmenu })
  call NERDTreeAddMenuItem({
    \ 'text': 'cabal (i)nstall',
    \ 'shortcut': 'i',
    \ 'callback': 'NERDTreeCabalInstall',
    \ 'parent': l:cabalSubmenu })
endfunction
" }}}

" {{{ Public interface
function NERDTreeCabalMenuEnabled()
  return filereadable(s:cabalConfPath())
endfunction

function NERDTreeCabalBuild()
  call cabal#Execute('build')
endfunction

function NERDTreeCabalInstall()
  call cabal#Execute('install')
endfunction
" }}}

" {{{ Execution
call s:SetupCabalSubmenu()
" }}}
