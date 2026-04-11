-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lang/typescript.lua — typescript-tools          ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	{
		'pmizio/typescript-tools.nvim',
		ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'tsx', 'jsx' },
		dependencies = {
			'nvim-lua/plenary.nvim',
			'neovim/nvim-lspconfig',
		},
		opts = {
			settings = {
				tsserver_file_preferences = {
					includeInlayParameterNameHints = 'all',
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
			},
		},
		keys = {
			{ '<leader>co', '<cmd>TSToolsOrganizeImports<CR>',          ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, desc = 'TS: Organize imports' },
			{ '<leader>cu', '<cmd>TSToolsRemoveUnusedImports<CR>',      ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, desc = 'TS: Remove unused imports' },
			{ '<leader>cf', '<cmd>TSToolsFixAll<CR>',                   ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, desc = 'TS: Fix all' },
			{ '<leader>cg', '<cmd>TSToolsGoToSourceDefinition<CR>',     ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }, desc = 'TS: Go to source definition' },
		},
	},
}
