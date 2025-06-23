return {

	'echasnovski/mini.trailspace', version = '*',

	config = function()
		require('mini.trailspace').setup()
		-- vim.api.nvim_set_hl(0, 'MiniTrailspace', {
		-- 	fg = 'NONE',
		-- 	bg = 'NONE',
		-- 	underline = false,
		-- 	bold = false,
		-- })
	end
}
