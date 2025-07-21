return {

	"hiphish/rainbow-delimiters.nvim",
	cond = not vim.g.vscode,

	config =  function ()

		vim.g.rainbow_delimiters = {
			-- This is to mimic VSCode's default
			highlight = {
				'RainbowDelimiterYellow',
				'RainbowDelimiterRed',
				'RainbowDelimiterBlue',
				-- 'RainbowDelimiterOrange',
				-- 'RainbowDelimiterGreen',
				-- 'RainbowDelimiterViolet',
				-- 'RainbowDelimiterCyan',
			},
		}

	end
}
