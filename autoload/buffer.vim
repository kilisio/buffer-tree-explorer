let s:file_regex = '\v^(:?├|─|└|│|\s)+[◎•]*\s*(\w|\.|\/|-)+ ⇒ (\d+)$'

" MakePageBuffer creates an empty buffer filled with line-separated 'contents'
function! buffer#MakeBuffer(contents, current_buffer_number)

  " make buffer and set attributes
  " exec ':to 60 vnew'
  aboveleft vnew
  setlocal nobuflisted noswapfile wrap buftype=nofile bufhidden=delete nonu nornu nocursorline
  execute ":file BufferTree"

  syntax match TreeCurrentBufferFile /\v◎ (\w|\.|\/|-)+ ⇒ (\d+)$/
  syntax match TreePath /\v(\w|\.|\/|-)+$/
  syntax match TreeFile /\v• (\w|\.|\/|-)+/
  syntax match TreeFilePath /\v• (\w|\.|\/|-).*\//
  syntax match TreeBranch /\v(├|─|└|│)/

  highlight TreePath guifg=white gui=italic
  highlight TreeFilePath guifg=white gui=italic
  highlight TreeFile guifg=gray
  highlight TreeCurrentBufferFile gui=bold guifg=yellow
  highlight TreeBranch guifg=white

  " typescript
  syntax match TypescriptFile /\v(•\s|\w|\.|-)*\.ts/
  highlight TypescriptFile guifg=#b57614
  " markdown
  syntax match MarkdownFile /\v(•\s|\w|\.|-)*\.md/
  highlight MarkdownFile guifg=#d5c4a1
  " bash
  syntax match BashFile /\v(•\s|\w|\.|-)*\.sh/
  highlight BashFile guifg=#a89984
  " kotlin
  syntax match KtFile /\v(•\s|\w|\.|-)*\.kt/
  highlight KtFile guifg=#d65d0e
  syntax match KtsFile /\v(•\s|\w|\.|-)*\.kts/
  highlight KtsFile guifg=#d65d0e
  " javascript
  syntax match JavascriptFile /\v(•\s|\w|\.|-)*\.js/
  highlight JavascriptFile guifg=#98971a
  " json
  syntax match JsonFile /\v(•\s|\w|\.|-)*\.json/
  highlight JsonFile guifg=#b8bb26
  " rust
  syntax match RustFile /\v(•\s|\w|\.|-)*\.rs/
  highlight RustFile guifg=#9d0006
  " html
  syntax match HtmlFile /\v(•\s|\w|\.|-)*\.html/
  highlight HtmlFile guifg=#458588
  " css
  syntax match CssFile /\v(•\s|\w|\.|-)*\.css/
  highlight CssFile guifg=#83a598
  " yaml
  syntax match YamlFile /\v(•\s|\w|\.|-)*\.yaml/
  highlight YamlFile guifg=#8ec07c
  " text
  syntax match TextFile /\v(•\s|\w|\.|-)*\.txt/
  highlight TextFile guifg=#fbf1c7
  " go
  syntax match GoFile /\v(•\s|\w|\.|-)*\.go/
  highlight GoFile guifg=#fabd2f
  " python
  syntax match PythonFile /\v(•\s|\w|\.|-)*\.py/
  highlight PythonFile guifg=#427b58
  " toml
  syntax match TomlFile /\v(•\s|\w|\.|-)*\.toml/
  highlight TomlFile guifg=#d79921

  let allowed_lines = []
  let bufferline = -1

  " fill the buffer with contents
  let line_idx = 1
  for line in a:contents
    if line != ''

      call setline(line_idx, line)
      let matches = matchlist(line, s:file_regex)

      if len(matches) > 0
        if matches[3] == a:current_buffer_number
          let bufferline = line_idx
        endif
        call add(allowed_lines, line_idx)
      endif

      let line_idx += 1
    endif
  endfor

  " only make non-modifiable after everything has already been written
  setlocal nomodifiable
  return [bufferline, allowed_lines]

endfunction

" RefreshPageBuffer
function! buffer#RefreshBuffer()

  let contents = tree#BufferTree()

  let allowed_lines = []
  let bufferline = -1
  let current_buffer_number = bufnr()

  setlocal modifiable

  " delete the old buffer contents
  call deletebufline(current_buffer_number, 1, '$')

  " fill the buffer with contents
  let line_idx = 1
  for line in contents
    if line != ''

      call setline(line_idx, line)
      let matches = matchlist(line, s:file_regex)

      if len(matches) > 0
        if matches[3] == current_buffer_number
          let bufferline = line_idx
        endif
        call add(allowed_lines, line_idx)
      endif

      let line_idx += 1
    endif
  endfor

  setlocal nomodifiable
  return [bufferline, allowed_lines]

endfunction
