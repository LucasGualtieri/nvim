return {
	'MagicDuck/grug-far.nvim',
	config = function()
		require('grug-far').setup({
			folding = {
				enabled = true,
				foldlevel = 99,     -- open by default
				-- foldcolumn = '0',   -- hides the fold gutter
				-- foldlevelstart = 99
			},
		});
	end
}
