let s:save_cpo = &cpo
set cpo&vim

if !exists('s:candidates_cache')
  let s:candidates_cache = {}
endif

if !exists('g:neco_php_default_sources')
  let g:neco_php_default_sources = 'functions'
endif

function! neocomplcache#sources#php_complete#helper#get_candidates()
  let dicts = split(g:neco_php_default_sources, ',')
  let ret = []
  for dict in dicts
    call neocomplcache#sources#php_complete#helper#read_candidates(dict)
    let ret += s:candidates_cache[dict]
  endfor
  return ret
endfunction

function! neocomplcache#sources#php_complete#helper#read_candidates(dict_name) "{{{
  if !has_key(s:candidates_cache, a:dict_name)
    let s:candidates_cache[a:dict_name] = []
    let dict_file = s:get_dict_path(a:dict_name)
    if filereadable(dict_file)
      let candidates = []
      for line in readfile(dict_file)
        let cols        = split(line, '\t;\t')
        let word        = get(cols, 0, '')
        let extra       = get(cols, 1, '')
        let kind        = get(cols, 2, 'F')
        let menu        = get(cols, 3, a:dict_name)

        "info attribute has been cancelled.
        "reset kind and menu for functions.dict
        if a:dict_name == "functions"
            if len(extra) > 50
                let extra = strpart(extra, 0, 60-len(word)) . '..'
            endif
            let extra = '() ' . extra
            let kind = ''
            let menu = 'func'
        endif

        call add(candidates, {
          \ 'word' : word,
          \ 'abbr' : word.' '.extra,
          \ 'kind' : kind,
          \ 'menu' : '['.menu.']'
          \})
      endfor
    endif
    let s:candidates_cache[a:dict_name] = candidates
  endif
endfunction "}}}

function! s:get_dict_path(dict_name) "{{{
  let dict_files = split(globpath(&runtimepath, 'autoload/neocomplcache/sources/php_complete/'.a:dict_name.'.dict'), '\n')
  if empty(dict_files)
    return ''
  else
    return dict_files[0]
  endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
