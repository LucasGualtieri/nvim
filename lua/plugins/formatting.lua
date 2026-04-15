-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/formatting.lua — conform.nvim + nvim-lint      ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── Conform (formatting) ──────────────────────────────────
	{
		'stevearc/conform.nvim',
		event = 'BufWritePre',
		cmd = 'ConformInfo',
		opts = {
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = true,
			-- },
			formatters_by_ft = {
				python          = { 'ruff_format', 'ruff_organize_imports' },
				javascript      = { 'prettier' },
				typescript      = { 'prettier' },
				javascriptreact = { 'prettier' },
				typescriptreact = { 'prettier' },
				json            = { 'prettier' },
				css             = { 'prettier' },
				html            = { 'prettier' },
				lua             = { 'stylua' },
				java            = {}, -- jdtls handles formatting
				c               = {}, -- clangd handles formatting via LSP
				cpp             = {}, -- clangd handles formatting via LSP
				tex             = {}, -- VimTeX / latexmk; do not run conform here
			},
		},
	},

	-- ── nvim-lint (linting) ───────────────────────────────────
	{
		'mfussenegger/nvim-lint',
		event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
		config = function()
			local lint = require('lint')

			lint.linters_by_ft = {
				javascript = { 'eslint_d' },
				typescript = { 'eslint_d' },
			}

			vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
				group = vim.api.nvim_create_augroup('NvimLint', { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
