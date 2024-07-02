require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = require('telescope.actions').move_selection_previous, -- move up
                ["<C-j>"] = require('telescope.actions').move_selection_next, -- move down
            },
        },
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
