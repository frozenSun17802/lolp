function mdopenlink#GetText(line_start, column_start, line_end, column_end)
    let lines = getline(a:line_start, a:line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: a:column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][a:column_start - 1:]
    return join(lines, "\n")
endfunction

function mdopenlink#OpenLink()
    let [link_line_start, link_column_start] = searchpos('(', 'bcnz')
    let [link_line_end, link_column_end] = searchpos(')', 'cnz')
    let [text_line_start, text_column_start] = searchpos('[', 'bcnz')
    let [text_line_end, text_column_end] = searchpos(']', 'cnz')
    let [buf_num, cursor_line, cursor_column, val_off] = getpos(".")

    let cursor_in_link = (link_line_start == cursor_line || link_line_end == cursor_line) && (cursor_column >= link_column_start && cursor_column <= link_column_end)
    let cursor_in_text = (text_line_start == cursor_line || text_line_end == cursor_line) && (cursor_column >= text_column_start && cursor_column <= text_column_end)

    if cursor_in_link || cursor_in_text
        let open_file = mdopenlink#GetText(link_line_start, link_column_start+1, link_line_end, link_column_end-1)
        execute 'edit' open_file
    endif
endfunction
