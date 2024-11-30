return {
	{ "nvzone/volt" },
	{ "nvzone/minty", cmd = { "Shades", "Huefy" } },
	{
		"norcalli/nvim-colorizer.lua",
		config = function ()
			-- Attaches to every FileType mode
			-- require 'colorizer'.setup()

			-- Attach to certain Filetypes, add special configuration for `html`
			-- Use `background` for everything else.
			require 'colorizer' .setup {
				'css';
				'javascript';
				html = { mode = 'foreground'; }
			}
		end
	},
	-- {
	-- 	"RRethy/vim-hexokinase",
	-- 	build = 'make hexokinase',
	-- }
}
