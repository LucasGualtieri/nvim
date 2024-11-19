local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
	vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

	-- Keybinding to open the Nvim tree and focus the current file
	-- vim.keymap.set('n', '-', function()
	--
	-- 	-- Wait for a brief moment before focusing the file
	-- 	vim.defer_fn(function()
	-- 		-- Focus the current file in the tree after it opens
	-- 		require('nvim-tree.api').tree.find_file({ focus = true })
	-- 	end, 1000)  -- Delay of 100ms
	--
	-- 	vim.defer_fn(function()
	-- 		-- Open the Nvim Tree
	-- 		require('nvim-tree.api').tree.open()
	-- 	end, 1000)  -- Delay of 100ms
	--
	-- end, { noremap = true, silent = true })

	-- Keybinding to focus the current file in Nvim Tree
	vim.api.nvim_set_keymap('n', '-', [[:lua require('nvim-tree.api').tree.find_file({ focus = false })<CR>]], { noremap = true, silent = true })

end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup {

	on_attach = my_on_attach,
	sort = { sorter = "case_sensitive", },
	view = {
		adaptive_size = true, -- Enables dynamic width
		-- width = 30,              -- Optional fallback width
		number = true,           -- Enable absolute line numbers
		relativenumber = true,   -- Enable relative line numbers (optional)
	},

	renderer = { group_empty = true, },

	git = { enable = true, },

	-- filters = { dotfiles = true, },
}
