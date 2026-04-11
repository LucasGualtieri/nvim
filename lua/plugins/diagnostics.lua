-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/diagnostics.lua — diagnostic display           ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	{
		'rachartier/tiny-inline-diagnostic.nvim',
		event = 'LspAttach',
		priority = 1000,
		config = function()
			-- ── vim.diagnostic.config ─────────────────────────────
			vim.diagnostic.config({
				virtual_text = false, -- tiny-inline-diagnostic handles this
				virtual_lines = false,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
			})

			require('tiny-inline-diagnostic').setup({
				preset = 'modern',
			})

			-- ── Keymaps ───────────────────────────────────────────
			-- vim.keymap.set('n', '<leader>td', function()
			-- 	require('tiny-inline-diagnostic').toggle()
			-- end, { desc = 'Toggle inline diagnostics' })

			vim.keymap.set('n', 'gK', function()
				local current = vim.diagnostic.config()
				vim.diagnostic.config({
					virtual_lines = not current.virtual_lines,
				})
			end, { desc = 'Toggle virtual_lines diagnostics' })
		end,
	},
}
