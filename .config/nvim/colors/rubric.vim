hi clear
syntax reset
set background=light
let g:colors_name = "rubric"

" normal black
hi Normal                    ctermfg=0    ctermbg=none cterm=none
hi Statement                 ctermfg=0    ctermbg=none cterm=none
hi Constant                  ctermfg=0    ctermbg=none cterm=none
hi PreProc                   ctermfg=0    ctermbg=none cterm=none
hi Identifier                ctermfg=0    ctermbg=none cterm=none
hi Special                   ctermfg=0    ctermbg=none cterm=none
hi Type                      ctermfg=0    ctermbg=none cterm=none

" bold black
hi Bold                      ctermfg=0    ctermbg=none cterm=bold
hi Title                     ctermfg=0    ctermbg=none cterm=bold
hi Directory                 ctermfg=0    ctermbg=none cterm=bold
hi diffFile                  ctermfg=0    ctermbg=none cterm=bold
hi diffNewFile               ctermfg=0    ctermbg=none cterm=bold
hi diffLine                  ctermfg=0    ctermbg=none cterm=bold
hi diffIndexLine             ctermfg=0    ctermbg=none cterm=bold
hi diffSubname               ctermfg=0    ctermbg=none cterm=bold
hi manSectionHeading         ctermfg=0    ctermbg=none cterm=bold

" italic black
hi Italic                    ctermfg=0    ctermbg=none cterm=italic
hi Underlined                ctermfg=0    ctermbg=none cterm=italic
hi String                    ctermfg=0    ctermbg=none cterm=italic
hi markdownLinkText          ctermfg=0    ctermbg=none cterm=italic

" normal red
hi Comment                   ctermfg=1    ctermbg=none cterm=none
hi markdownCodeDelimiter     ctermfg=1    ctermbg=none cterm=none
hi markdownLinkDelimiter     ctermfg=1    ctermbg=none cterm=none
hi markdownLinkTextDelimiter ctermfg=1    ctermbg=none cterm=none
hi markdownId                ctermfg=1    ctermbg=none cterm=none
hi markdownIdDeclaration     ctermfg=1    ctermbg=none cterm=none
hi htmlTag                   ctermfg=1    ctermbg=none cterm=none
hi htmlEndTag                ctermfg=1    ctermbg=none cterm=none
hi htmlString                ctermfg=1    ctermbg=none cterm=none
hi htmlTagName               ctermfg=1    ctermbg=none cterm=none
hi htmlSpecialTagName        ctermfg=1    ctermbg=none cterm=none
hi htmlArg                   ctermfg=1    ctermbg=none cterm=none
hi htmlValue                 ctermfg=1    ctermbg=none cterm=none
hi haskellPragma             ctermfg=1    ctermbg=none cterm=none
hi SpecialKey                ctermfg=1    ctermbg=none cterm=none
hi diffRemoved               ctermfg=1    ctermbg=none cterm=none

" normal green
hi diffAdded                 ctermfg=2    ctermbg=none cterm=none

" bold red
hi Todo                      ctermfg=1    ctermbg=none cterm=bold
hi markdownHeadingDelimiter  ctermfg=1    ctermbg=none cterm=bold

" italic red
hi markdownUrl               ctermfg=1    ctermbg=none cterm=italic
hi htmlString                ctermfg=1    ctermbg=none cterm=italic

" other
hi Visual                    ctermfg=none ctermbg=7    cterm=none
hi StatusLine                ctermfg=none ctermbg=7    cterm=none
hi StatusLineNC              ctermfg=none ctermbg=7    cterm=none
hi NonText                   ctermfg=7    ctermbg=none cterm=none
hi Search                    ctermfg=0    ctermbg=9    cterm=none
hi IncSearch                 ctermfg=0    ctermbg=9    cterm=none
hi MatchParen                ctermfg=0    ctermbg=7    cterm=none
hi fzf1                      ctermfg=none ctermbg=7    cterm=none
hi fzf2                      ctermfg=none ctermbg=7    cterm=none
hi fzf3                      ctermfg=none ctermbg=7    cterm=none
