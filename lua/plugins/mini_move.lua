return {

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
				-- line_down = '<S-j>',
				-- line_up = '<S-k>',
			},
		})
	end,
}
