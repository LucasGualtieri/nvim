return {
	{
		"neovim/nvim-lspconfig",
		cond = not vim.g.vscode,

		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" }}}},
			},
			{
				"mfussenegger/nvim-jdtls",
				ft = "java", -- isso garante que ele só carregue em arquivos Java
			},
		},

		config = function()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local on_attach = function(_, bufnr)

				-- Enable inlay hints for this buffer (Neovim 0.10+)
				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(false)
				end

				-- Optional keybinding to toggle inlay hints
				vim.keymap.set("n", "<leader>ih", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }))
				end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
			end

			-- if vim.g.have_nerd_font then
			vim.diagnostic.config({
				-- underline = true,
				-- update_in_insert = false,
				virtual_text = {
					-- spacing = 4,
					-- prefix = "●", -- Change this to suit your theme
					current_line = false;
				},
				signs = { text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				} },
			})
			-- end

			require('lspconfig').lua_ls.setup {
				on_attach = on_attach,
			}

			require('lspconfig').pyright.setup {
				on_attach = on_attach,
			}

			require('lspconfig').elixirls.setup {
				on_attach = on_attach,
				cmd = { os.getenv("HOME") .. "/.local/elixir-ls/language_server.sh" },
				settings = {
					elixirLS = {
						dialyzerEnabled = false,
						fetchDeps = false
					}
				}
			}

			require('lspconfig').clangd.setup {

				on_attach = on_attach,

				cmd = { 'clangd', '--background-index', '--clang-tidy' },
				on_new_config = function(new_config, root_dir)
					local has_ccjson = require("plenary.path"):new(root_dir .. "/compile_commands.json"):exists()

					if not has_ccjson then
						-- Define flags baseados na extensão do arquivo principal aberto
						local filename = vim.api.nvim_buf_get_name(0)
						if filename:match("%.c$") then
							new_config.init_options = {
								fallbackFlags = { "-std=c17" }
							}
						elseif filename:match("%.cpp$") or filename:match("%.cc$") or filename:match("%.cxx$") then
							new_config.init_options = {
								fallbackFlags = { "-std=c++23" }
							}
						else
							new_config.init_options = {
								fallbackFlags = { "-std=c++23" } -- padrão genérico
							}
						end
					end
				end,
			}

			vim.api.nvim_create_autocmd("LspAttach", {

				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

				callback = function(event)

					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
					vim.keymap.set("n", "<leader>fl", function()
						vim.diagnostic.open_float(nil, { focusable = true })
					end, { noremap = true, silent = true, desc = "LSP: Float diagnostics" })

					-- 💡 Disable semantic tokens for clangd to better integrate the VSCode theme. Não é mais necessário.
					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client and client.name == "clangd" and client.server_capabilities.semanticTokensProvider then
					-- 	client.server_capabilities.semanticTokensProvider = nil
					-- end

					-- 💡 Disable semantic tokens for every language to better integrate the VSCode theme
					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client and client.server_capabilities.semanticTokensProvider then
					-- 	client.server_capabilities.semanticTokensProvider = nil
					-- end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					-- 	local highlight_augroup =
					-- 		vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					-- 	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					-- 		buffer = event.buf,
					-- 		group = highlight_augroup,
					-- 		callback = vim.lsp.buf.document_highlight,
					-- 	})
					--
					-- 	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					-- 		buffer = event.buf,
					-- 		group = highlight_augroup,
					-- 		callback = vim.lsp.buf.clear_references,
					-- 	})
					--
					-- 	vim.api.nvim_create_autocmd("LspDetach", {
					-- 		group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					-- 		callback = function(event2)
					-- 			vim.lsp.buf.clear_references()
					-- 			vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					-- 		end,
					-- 	})
					-- end
				end,
			})
		end
	},

	-- Autocompletion
	{

		"hrsh7th/nvim-cmp",
		cond = not vim.g.vscode,

		event = "InsertEnter",
		dependencies = {

			"saadparwaiz1/cmp_luasnip",

			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),

				dependencies = {
					{ 'rafamadriz/friendly-snippets',
						config = function() require('luasnip.loaders.from_vscode').lazy_load() end
					},
				},
			},

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					-- ['<Tab>'] = cmp.mapping.select_next_item(),
					-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					-- ['<CR>'] = cmp.mapping.confirm({ select = true }),

					['<C-e>'] = cmp.mapping(function(_)
						if cmp.visible() then
							cmp.abort()
						else
							cmp.complete()
						end
					end, { "i", "c" }),

					-- ["<C-e>"] = cmp.mapping.complete({}),
					-- ['<C-e>'] = cmp.mapping.abort(),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),

					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
}
