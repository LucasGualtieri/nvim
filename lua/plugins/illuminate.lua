return {

	"RRethy/vim-illuminate",
	cond = not vim.g.vscode,

	config = function()

		-- Set custom highlights for illuminate
		-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#484848" }) -- Replace with desired color
		-- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#484848" })
		-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#484848" })

		-- default configuration
		require('illuminate').configure({
			-- disable_keymaps: disable default keymaps
			disable_keymaps = true,
			-- delay: delay in milliseconds
			delay = 0,
			-- under_cursor: whether or not to illuminate under the cursor
			under_cursor = true,
			providers = { 'lsp', 'treesitter', 'regex' },
			filetype_overrides = {},
			filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive' },
			filetypes_allowlist = {},
			modes_denylist = {},
			modes_allowlist = {},
			providers_regex_syntax_denylist = {},
			providers_regex_syntax_allowlist = {},
			large_file_cutoff = 10000,
			-- large_file_config: config to use for large files (based on large_file_cutoff).
			-- Supports the same keys passed to .configure
			-- If nil, vim-illuminate will be disabled for large files.
			large_file_overrides = nil,
			-- min_count_to_highlight: minimum number of matches required to perform highlighting
			min_count_to_highlight = 1,
			should_enable = function(bufnr) return true end,
			-- case_insensitive_regex: sets regex case sensitivity
			case_insensitive_regex = false,
		})
	end,
}
