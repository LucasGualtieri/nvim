return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",

		config = function ()

			vim.o.foldcolumn = '1' -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			vim.keymap.set('n', 'zK', function ()
				 local winid = require('ufo').peekFoldedLinesUnderCursor()
				 if not winid then
					 vim.lsp.buf.hover()
				 end
			end)

			require('ufo').setup({
				---@diagnostic disable-next-line: unused-local
				provider_selector = function(bufnr, filetype, buftype)
					return {'lsp', 'indent'}
				end
			})
		end
	},

	{

		"chrisgrieser/nvim-origami",

		event = "VeryLazy",

		opts = {}, -- needed even when using default config

		config = function ()

			-- default settings
			require("origami").setup {

				keepFoldsAcrossSessions = true,

				pauseFoldsOnSearch = true,

				setupFoldKeymaps = true,

				-- `h` key opens on first column, not at first non-blank character or before
				hOnlyOpensOnFirstColumn = false,
			}
		end
	}
}
