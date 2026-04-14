return {

	"chrisgrieser/nvim-origami",

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

			useLspFoldsWithTreesitterFallback = {
				enabled = true,
				foldmethodIfNeitherIsAvailable = "indent",
			},

			pauseFoldsOnSearch = true,

			foldtext = {
				enabled = true,
				padding = {
					character = " ",
					width = 1,
					hlgroup = nil,
				},
				lineCount = {
					template = "%d lines", -- `%d` is replaced with the number of folded lines
					hlgroup = "Comment",
				},
				diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
				gitsignsCount = true, -- requires `gitsigns.nvim`
			},

			autoFold = {
				enabled = false,
				kinds = { "comment", "imports" },
			},

			foldKeymaps = {
				setup = false,
				closeOnlyOnFirstColumn = true,
			},
		})

		local function normal_fold(cmd)
			pcall(function()
				vim.cmd.normal({ cmd, bang = true })
			end)
		end

		vim.keymap.set("n", ",", function()
			for _ = 1, vim.v.count1 do
				normal_fold("zc")
			end
		end, { desc = "Origami: fold close (zc)" })

		vim.keymap.set("n", ".", function()
			for _ = 1, vim.v.count1 do
				if vim.fn.foldclosed(".") > -1 then
					normal_fold("zo")
				end
			end
		end, { desc = "Origami: fold open (zo)" })
	end
}
