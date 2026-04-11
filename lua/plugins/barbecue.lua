return {

	"utilyre/barbecue.nvim",

	name = "barbecue",
	version = "*",

	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},

	-- Barbecue's default LspAttach handler calls navic.attach() for every client
	-- with documentSymbol; a second client (e.g. spring-boot) then hits navic's
	-- "already attached" warning. Prefer jdtls via navic's auto_attach + preference.
	opts = {
		attach_navic = false,
	},
	config = function(_, opts)
		require("nvim-navic").setup({
			lsp = {
				auto_attach = true,
				preference = { "jdtls" },
			},
		})
		require("barbecue").setup(opts)
	end,
}
