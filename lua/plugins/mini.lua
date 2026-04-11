return {

	{
		'echasnovski/mini.trailspace',
		version = '*',
		config = function()
			require('mini.trailspace').setup({})
		end,
	},

	{
		'echasnovski/mini.move', version = '*',

		config = function()

			require("mini.move").setup({

				mappings = {

					left = '<S-h>',
					right = '<S-l>',
					down = '<S-j>',
					up = '<S-k>',

					line_left = '<S-h>',
					line_right = '<S-l>',
					-- line_* = Normal only; use '' so <S-j>/<S-k> only move selection (down/up).
					line_down = '',
					line_up = '',
				},
			})
		end,
	},
}
