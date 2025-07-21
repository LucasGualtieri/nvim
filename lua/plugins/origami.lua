return {

	"chrisgrieser/nvim-origami",
	cond = not vim.g.vscode,

	event = "VeryLazy",
	opts = {}, -- needed even when using default config

	-- recommended: disable vim's auto-folding
	init = function()
		-- vim.opt.foldenable = true
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,

	config = function()

		require("origami").setup({

			useLspFoldsWithTreesitterFallback = true, -- required for `autoFold`

			pauseFoldsOnSearch = true,

			foldtext = {
				enabled = true,
				padding = 1,
				lineCount = {
					template = "%d lines", -- `%d` is replaced with the number of folded lines
					hlgroup = "Comment",
				},
				diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
				gitsignsCount = true, -- requires `gitsigns.nvim`
			},

			autoFold = {
				enabled = false,
				kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
			},

			foldKeymaps = {
				setup = true, -- modifies `h` and `l`
				hOnlyOpensOnFirstColumn = true,
			},
		})
	end
}
