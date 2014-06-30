" php_complete.vim
" Maintainer:  Yuhei Kagaya <yuhei.kagaya@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Last Change: 2012/11/26
" Version:     0.1

let s:save_cpo = &cpo
set cpo&vim

function! neocomplcache#sources#php_complete#define() "{{{
  return s:source
endfunction "}}}
let s:source = {
      \ 'name' : 'php_complete',
      \ 'kind' : 'manual',
      \ 'filetypes' : { 'php' : 1, },
      \}

function! s:source.get_keyword_pos(cur_text)"{{{
  if neocomplcache#within_comment()
    return -1
  endif

  let l:pattern = neocomplcache#get_keyword_pattern_end('php')
  let [l:cur_keyword_pos, l:cur_keyword_str] = neocomplcache#match_word(a:cur_text, l:pattern)
  return l:cur_keyword_pos
endfunction"}}}

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) "{{{
  let l:cur_text = neocomplcache#get_cur_text()

  let l:php_class_variable = matchstr(l:cur_text, '\zs\(\$\h\w\+\)\ze->\h\w*$')
  if len(l:php_class_variable) > 0
    return []
  endif

  let l:php_class_name = matchstr(l:cur_text, '\zs\(\h\w\+\)\ze::\h\w*$')
  if len(l:php_class_name) > 0
    return []
  endif
  let candidates = neocomplcache#sources#php_complete#helper#get_candidates()

  let filtered_candidates = neocomplcache#keyword_filter(deepcopy(candidates), a:cur_keyword_str)
  return filtered_candidates
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
