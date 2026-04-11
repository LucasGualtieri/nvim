return {

	"hiphish/rainbow-delimiters.nvim",

	config =  function ()

		vim.g.rainbow_delimiters = {
			highlight = {
				'RainbowDelimiterYellow',
				'RainbowDelimiterRed',
				'RainbowDelimiterBlue',
			},
		}
	end
}
