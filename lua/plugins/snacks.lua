return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	cond = not vim.g.vscode,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		notifier = { enabled = true },
		input = { enabled = true },
		-- select = { enabled = true },
		image = { enabled = true },
		-- dashboard = { enabled = true },
		-- explorer = { enabled = true },
		-- indent = { enabled = true },
		-- scope = { enabled = true },
		-- statuscolumn = { enabled = true },
		-- words = { enabled = true },
	},
}
