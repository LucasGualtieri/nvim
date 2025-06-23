return {

	{
		'lukas-reineke/indent-blankline.nvim',

		main = 'ibl', opts = {},

		config = function()
			require("ibl").setup {
				indent = { char = "▏" },
				scope = { enabled = false }
			}
		end
	},

	{
		'echasnovski/mini.indentscope', version = '*',
		config = function()
			require("mini.indentscope").setup({
				draw = {
					-- Delay (in ms) between event and start of drawing scope indicator
					delay = 0,
					animation = require('mini.indentscope').gen_animation.none(),
				},
				options = {
					border = 'top',
					indent_at_cursor = false,
				},
				symbol ='▏',
			})
		end,
	},
}
