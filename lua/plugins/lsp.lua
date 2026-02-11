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

			-- 1. Setup Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities() -- [cite: 705]
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- 2. Define on_attach (Optional: Consider moving entirely to LspAttach autocmd)
			local on_attach = function(_, bufnr)
				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) -- [cite: 549]
				end
				vim.keymap.set("n", "<leader>ih", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
				end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
			end

			-- 3. Configure Diagnostics
			vim.diagnostic.config({
				virtual_text = { current_line = false },
				signs = { text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				} },
			})

			-- 4. Define Server Configurations (Native Method) [cite: 7, 32]

			-- Lua LS
			vim.lsp.config.lua_ls = {
				on_attach = on_attach, -- [cite: 355]
				capabilities = capabilities, -- [cite: 315]
			}

			-- Pyright
			vim.lsp.config.pyright = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Elixir LS
			vim.lsp.config.elixirls = {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { os.getenv("HOME") .. "/.local/elixir-ls/language_server.sh" }, -- [cite: 319]
				settings = { -- [cite: 368]
					elixirLS = {
						dialyzerEnabled = false,
						fetchDeps = false
					}
				}
			}

			-- Clangd
			vim.lsp.config.clangd = {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { 'clangd', '--background-index', '--clang-tidy' },
				-- 'on_new_config' is deprecated. Use 'before_init' to modify params dynamically
				before_init = function(params, config)
					local root_dir = config.root_dir -- [cite: 367]
					if not root_dir then return end

					local has_ccjson = require("plenary.path"):new(root_dir .. "/compile_commands.json"):exists()

					if not has_ccjson then
						local filename = vim.api.nvim_buf_get_name(0)
						local fallback_flag = "-std=c++23" -- default

						if filename:match("%.c$") then
							fallback_flag = "-std=c17"
						end

						-- Inject into initializationOptions
						params.initializationOptions = {
							fallbackFlags = { fallback_flag }
						}
					end
				end,
			}

			-- 5. Enable the servers [cite: 205]
			vim.lsp.enable({ 'lua_ls', 'pyright', 'elixirls', 'clangd' })

			-- 6. LspAttach Autocommand (Kept from your original code)
			vim.api.nvim_create_autocmd("LspAttach", { -- [cite: 117]
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame") -- [cite: 489]
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" }) -- [cite: 430]
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					vim.keymap.set("n", "<leader>fl", function()
						vim.diagnostic.open_float(nil, { focusable = true })
					end, { noremap = true, silent = true, desc = "LSP: Float diagnostics" })
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
