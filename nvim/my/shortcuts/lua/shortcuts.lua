local function expand_current_line(callback)
    local row1 = vim.api.nvim_win_get_cursor(0)[1]
    local shortcut = vim.api.nvim_get_current_line()
    local fulltext_lines, cursor_rel_row1 = callback(shortcut)
    vim.api.nvim_buf_set_lines(0, row1 - 1, row1, true, fulltext_lines)
    vim.api.nvim_win_set_cursor(0, {row1 + cursor_rel_row1 - 1, 0})
end

local function cpp_ns(ns_path)
    local lines = {}
    local namespaces = vim.split(ns_path, '::', true)
    for i, ns in ipairs(namespaces) do
        lines[i] = 'namespace ' .. ns .. ' {'
    end
    local n = #namespaces
    lines[n + 1] = ''  -- body
    for i = 1, n do
        lines[n + 1 + i] = '}  // namespace ' .. namespaces[n - i + 1]
    end
    return lines, n + 1
end

return {
    expand_current_line = expand_current_line,
    cpp_ns = cpp_ns,
}
