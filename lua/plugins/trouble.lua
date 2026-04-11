-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/trouble.lua — diagnostics/symbols panel        ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	{
		'folke/trouble.nvim',
		cmd = 'Trouble',
		keys = {
			{ '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',              desc = 'Trouble: Project diagnostics' },
			{ '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Trouble: Buffer diagnostics' },
			{ '<leader>cs', '<cmd>Trouble symbols toggle<CR>',                  desc = 'Trouble: LSP symbols' },
			{ '<leader>cl', '<cmd>Trouble lsp toggle<CR>',                      desc = 'Trouble: LSP references/defs' },
			{ '<leader>xq', '<cmd>Trouble qflist toggle<CR>',                   desc = 'Trouble: Quickfix list' },
			{ '<leader>xl', '<cmd>Trouble loclist toggle<CR>',                  desc = 'Trouble: Location list' },
		},
		opts = {
			auto_close = true,
			use_diagnostic_signs = true,
		},
	},
}
