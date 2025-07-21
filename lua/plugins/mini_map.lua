-- This one looks okay but performs better?
return {

	'echasnovski/mini.map', version = '*',
	cond = not vim.g.vscode,

	config = function()

		vim.keymap.set('n', '<leader>mm', function()
		  require('mini.map').toggle()
		end, { desc = 'Toggle minimap' })

		-- Force refresh the minimap
		vim.keymap.set('n', '<leader>mr', function()
		  require('mini.map').refresh()
		end, { desc = 'Refresh minimap' })

		require("mini.map").setup({

			-- Highlight integrations (none by default)
			integrations = {
				-- require('mini.map').gen_integration.builtin_search(),
				require('mini.map').gen_integration.diagnostic(),
				-- require('mini.map').gen_integration.diff(),
				-- require('mini.map').gen_integration.gitsigns(),
			},

			symbols = {
				encode = require('mini.map').gen_encode_symbols.dot('4x2'), -- less squished
				-- Scrollbar parts for view and line. Use empty string to disable any.
				scroll_line = '█',
				scroll_view = '┃',
				-- scroll_line = '',
				-- scroll_view = '',
			},

			-- Window options
			window = {
				-- Whether window is focusable in normal way (with `wincmd` or mouse)
				focusable = false,

				-- Side to stick ('left' or 'right')
				side = 'right',

				-- Whether to show count of multiple integration highlights
				show_integration_count = false,

				-- Total width
				width = 10,

				-- Value of 'winblend' option
				winblend = 25,

				-- Z-index
				zindex = 10,
			},
		})

		-- So that is opens by default
		require('mini.map').open()
	end
}
