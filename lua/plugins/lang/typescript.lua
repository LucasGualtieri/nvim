-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lang/typescript.lua — vtsls (TypeScript LSP)  ║
-- ╚══════════════════════════════════════════════════════════╝

local TS_FT = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

return {
	{
		'neovim/nvim-lspconfig',
		ft = TS_FT,
		init = function()
			-- vtsls publishes diagnostics and also supports pull (textDocument/diagnostic).
			-- Advertising pull + push can surface the same TS code twice (e.g. two × 2304).
			-- See https://github.com/neovim/neovim/issues/29927
			vim.lsp.config('vtsls', {
				filetypes = TS_FT,
				capabilities = {
					textDocument = {
						diagnostic = vim.NIL,
					},
				},
				settings = {
					vtsls = {
						autoUseWorkspaceTsdk = true,
					},
					typescript = {
						inlayHints = {
							parameterNames        = { enabled = 'all' },
							parameterTypes        = { enabled = true },
							variableTypes         = { enabled = true },
							returnTypes           = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
						},
					},
					javascript = {
						inlayHints = {
							parameterNames        = { enabled = 'all' },
							parameterTypes        = { enabled = true },
							variableTypes         = { enabled = true },
							returnTypes           = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
						},
					},
				},
			})
		end,
		keys = {
			-- { '<leader>co', function()
			-- 	vim.lsp.buf.code_action({ apply = true, context = { only = { 'source.organizeImports' }, diagnostics = {} } })
			-- end, ft = TS_FT, desc = 'TS: Organize imports' },
			-- { '<leader>cu', function()
			-- 	vim.lsp.buf.code_action({ apply = true, context = { only = { 'source.removeUnusedImports' }, diagnostics = {} } })
			-- end, ft = TS_FT, desc = 'TS: Remove unused imports' },
			-- { '<leader>cf', function()
			-- 	vim.lsp.buf.code_action({ apply = true, context = { only = { 'source.fixAll' }, diagnostics = {} } })
			-- end, ft = TS_FT, desc = 'TS: Fix all' },
		},
	},
}
