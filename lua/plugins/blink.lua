-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/completion.lua — blink.cmp                     ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	{
		'saghen/blink.cmp',
		version = '1.*',
		event = 'InsertEnter',
		dependencies = {
			'rafamadriz/friendly-snippets',
			'erooke/blink-cmp-latex',
		},
		opts = {
			-- preset: Tab / S-Tab = snippet jump; add C-l / C-h like nvim-cmp + LuaSnip (only in insert via blink).
			keymap = {
				preset = 'default',
				['<C-l>'] = { 'snippet_forward', 'fallback' },
				['<C-h>'] = { 'snippet_backward', 'fallback' },
			},

			completion = {
				ghost_text = { enabled = false },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					draw = {
						treesitter = { 'lsp' },
					},
				},
			},

			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer', 'latex' },
				providers = {
					latex = {
						name = 'LaTeX',
						module = 'blink-cmp-latex',
					},
				},
			},

			fuzzy = {
				prebuilt_binaries = {
					download = true,
					ignore_version_mismatch = true,
				},
			},
		},

		config = function(_, opts)
			local blink = require('blink.cmp')
			blink.setup(opts)

			-- Inject blink capabilities into the global LSP config
			vim.lsp.config('*', {
				capabilities = blink.get_lsp_capabilities(),
			})
		end,
	},
}
