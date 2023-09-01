-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- return to last edit position when opening files
vim.cmd([[
    augroup restore_cursor_position
        autocmd!
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
    augroup END
]])

vim.wo.relativenumber = true
vim.api.nvim_set_option_value("colorcolumn", "80", {})
