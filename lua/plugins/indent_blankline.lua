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
		'LucasGualtieri/mini.indentscope', version = '*',

		config = function()

			local indent = require("mini.indentscope")

			indent.setup({

				symbol ='▏',

				draw = {
					-- Delay (in ms) between event and start of drawing scope indicator
					delay = 0,
					animation = indent.gen_animation.none(),
				},

				options = {
					border = 'top',
					indent_at_cursor = false,
					try_as_border = true
				},
			})
		end,

		-- vim.api.nvim_create_autocmd("filetype", {
		-- 	pattern = { "help", "markdown", "text" },
		-- 	callback = function()
		-- 		vim.b.miniindentscope_disable = true
		-- 	end,
		-- })
	},
}
