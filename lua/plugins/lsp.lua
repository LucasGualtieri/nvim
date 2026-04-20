-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lsp.lua — LSP stack (Mason, nvim-lspconfig,    ║
-- ║  and native vim.lsp.config/enable)                      ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── Mason ─────────────────────────────────────────────────
	{
		'mason-org/mason.nvim',
		cmd = 'Mason',
		build = ':MasonUpdate',
		opts = {
			ui = { border = 'rounded' },
		},
	},

	-- ── Mason-lspconfig (bridge) ──────────────────────────────
	{
		'mason-org/mason-lspconfig.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'mason-org/mason.nvim',
			'neovim/nvim-lspconfig',
		},
		opts = {
			ensure_installed = {
				'clangd',
				'pyright',
				'vtsls',
				'lua_ls',
				'jdtls',
				'texlab',
			},
			automatic_installation = false,
			-- jdtls is managed entirely by nvim-jdtls (plugins/lang/java.lua).
			-- Excluding it here prevents mason-lspconfig from calling vim.lsp.enable('jdtls')
			-- and launching a second, bare JVM instance alongside the configured one.
			automatic_enable = { exclude = { 'jdtls' } },
		},
	},

	-- ── Mason tool installer (formatters, linters) ────────────
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		event = 'VeryLazy',
		dependencies = { 'mason-org/mason.nvim' },
		opts = {
			ensure_installed = {
				-- Formatters
				'prettier',
				'black',
				'ruff',
				'stylua',
				-- Linters
				'eslint_d',
				-- Debug adapters
				'debugpy',
				'java-debug-adapter',
				'java-test',
				-- Spring Boot
				'vscode-spring-boot-tools',
			},
		},
	},

	-- ── nvim-lspconfig (config database only) ─────────────────
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'nvim-telescope/telescope.nvim',
			-- blink.cmp must run its config (which sets blink capabilities via
			-- vim.lsp.config('*', ...)) before vim.lsp.enable() is called here.
			-- Declaring it as a dependency guarantees that ordering.
			'saghen/blink.cmp',
		},
		config = function()
			-- Global LSP config — capabilities injected by blink.cmp via completion.lua
			vim.lsp.config('*', {
				root_markers = { '.git' },
			})

			vim.lsp.config('pyright', {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = 'workspace',
						},
					},
				},
			})

			-- Enable non-Java servers here.
			-- (clangd is enabled in lang/cpp.lua)
			-- (vtsls is configured in lang/typescript.lua via init, enabled below)
			-- Keep every server's enable here: duplicate nvim-lspconfig specs in lazy.nvim
			-- override `config` instead of chaining it, so a second spec would drop these keymaps.
			-- texlab: configured in plugins/lang/latex.lua (vim.lsp.config)
			vim.lsp.enable({ 'lua_ls', 'pyright', 'vtsls', 'texlab' })

			-- ── LspAttach keymaps ─────────────────────────────────
			vim.api.nvim_create_autocmd('LspAttach', {

				group = vim.api.nvim_create_augroup('LspKeymaps', { clear = true }),
				callback = function(args)

					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if not client then return end

					local bufnr = args.buf
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
					end

					-- Defer require so pickers work even if Telescope loads after this callback.
					local function tel(name)
						return function()
							require('telescope.builtin')[name]()
						end
					end

					map('n', 'gd', function()
						require('lsp.telescope_incoming_calls').definition_or_incoming_calls(bufnr)
					end, 'Definition or incoming calls')

					map('n', 'gi', tel('lsp_implementations'), 'Go to implementation')
					map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
					-- map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
					-- map('n', 'gr', tel('lsp_references'), 'Go to references')
					-- map('n', '<leader>D', tel('lsp_type_definitions'), 'Type definition')
					-- map('n', '<leader>ds', tel('lsp_document_symbols'), 'Document symbols')
					-- map('n', '<leader>ws', tel('lsp_dynamic_workspace_symbols'), 'Workspace symbols')

					map('n', '<leader>fl', function()
						vim.diagnostic.open_float({ bufnr = bufnr, focusable = true })
					end, 'Float diagnostics')

					if client:supports_method('textDocument/prepareCallHierarchy', { bufnr = bufnr }) and not vim.b[bufnr].lsp_call_hierarchy_keymap then
						vim.b[bufnr].lsp_call_hierarchy_keymap = true
						map('n', '<leader>ic', function()
							require('lsp.telescope_incoming_calls').incoming_calls()
						end, 'Incoming calls')
					end

					if client:supports_method('textDocument/codeAction', { bufnr = bufnr }) then
						map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
					end

					-- if client:supports_method('textDocument/formatting', { bufnr = bufnr }) then
					-- 	map('n', '<leader>f', function()
					-- 		vim.lsp.buf.format({ async = true })
					-- 	end, 'Format buffer')
					-- end
				end,
			})
		end,
	},
}
