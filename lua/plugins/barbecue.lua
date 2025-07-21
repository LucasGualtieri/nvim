return {

	"utilyre/barbecue.nvim",
	cond = not vim.g.vscode,

	name = "barbecue",
	version = "*",

	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},

	opts = { },
}
