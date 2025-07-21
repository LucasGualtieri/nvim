return {

	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false, build = ":TSUpdate",
		cond = not vim.g.vscode,

		config = function()

			require'nvim-treesitter.configs'.setup({

				modules = {},
				ignore_install = {},

				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

				sync_install = false,

				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				-- fold = { enable = true },
				-- indent = { enable = true },
			})
		end
	},

	{
		"nvim-treesitter/playground",
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
	}
}
