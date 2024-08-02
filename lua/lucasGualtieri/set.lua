vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- set expandtab
-- set shiftwidth = 4
-- set softtabstop = 4
-- set tabstop = 4
-- set autoindent
-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true