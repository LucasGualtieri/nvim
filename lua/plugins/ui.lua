-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/ui.lua — theme, statusline, UI enhancements    ║
-- ╚══════════════════════════════════════════════════════════╝

return {

	-- ── VSCode colorscheme ────────────────────────────────
	{
		"Mofiqul/vscode.nvim",

		config = function ()

			-- For dark theme (neovim's default)
			vim.o.background = 'dark'
			-- -- For light theme
			-- vim.o.background = 'light'

			local c = require('vscode.colors').get_colors()

			require('vscode').setup({

				-- Alternatively set style in setup
				-- style = 'light'

				-- Enable italic comment
				italic_comments = true,

				-- Enable transparent background
				transparent = false,

				-- Underline `@markup.link.*` variants
				underline_links = true,

				-- Disable nvim-tree background color
				disable_nvimtree_bg = true,

				-- Override colors (see ./lua/vscode/colors.lua)
				color_overrides = { vscLineNumber = '#484848' },

				-- Override highlight groups (see ./lua/vscode/theme.lua)
				-- Use :TSHighlightCapturesUnderCursor
				group_overrides = {
					-- this supports the same val table as vim.api.nvim_set_hl
					-- use colors from this colorscheme by requiring vscode.colors!
					Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = false },

					["@keyword.operator"] = { fg = c.vscPink, bold = false },  -- color for `new` and `delete`
					["@keyword.directive"] = { fg = c.vscPink, bold = false },
					["@lsp.type.property.lua"] = { fg = c.vscBlueGreen, bold = false },
					["@string.escape"] = { fg = "#D7BA7D", bold = false },

					QuickFixLine = { bg = c.vscSelection, bold = true },
				}
			})

			-- load the theme without affecting devicon colors.
			vim.cmd.colorscheme "vscode"
			vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = "#707070", bold = true })
			vim.api.nvim_set_hl(0, '@lsp.type.operator.cpp', { link = '' })  -- Remove o highlight do operador semântico para sobrescrevermos a cor
			-- vim.api.nvim_set_hl(0, "Visual", { bg = "#264F78", fg = "NONE" })

		-- once = true: all groups are global (namespace 0) so they only need to be
		-- applied once — the first Java buffer is enough. Without this, 35+ hl
		-- calls fire every time any Java file is opened.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			once = true,
			callback = function()
					-- Colors matching VSCode Dark+
					local pink = "#C586C0"
					local blue = "#569CD6"
					local teal = "#4EC9B0"
					local yellow = "#DCDCAA"
					local light_blue = "#9CDCFE"
					local fg_color = "#D4D4D4" -- VSCode standard foreground text

					local hl = function(group, fg)
						vim.api.nvim_set_hl(0, group, { fg = fg, default = false })
					end

					-- Packages, Imports
					hl("@keyword.import", blue)
					hl("javaImportDeclBlock", blue)
					hl("javaExternal", blue)

					-- Control Flow & Operators ('new', 'return', etc.)
					hl("@keyword.return", pink)
					hl("@keyword.exception", pink)
					hl("@keyword.conditional", pink)
					hl("@keyword.repeat", pink)
					hl("@keyword.operator.java", pink)
					hl("javaOperator", pink)
					hl("@keyword.java", pink) -- fallback for 'new' and other generic keywords

					-- The '@' symbol in annotations should be standard Foreground.
					-- Treesitter captures both '@' and the annotation name as @attribute; we set
					-- @attribute.java to fg_color so '@' stays white. The annotation name still
					-- appears teal because @lsp.type.annotation.java (LSP semantic tokens, higher
					-- priority) overrides only the name node — jdtls never applies 'annotation'
					-- to the '@' punctuation marker.
					hl("javaAnnotation", fg_color)          -- regex syntax fallback
					hl("@attribute.java", fg_color)         -- treesitter: '@' marker stays white

					-- Annotation Name itself (e.g. RestController) → teal via LSP
					hl("@lsp.type.annotation.java", teal)

					-- jdtls uses annotationMember for names in @Foo(name = value) (e.g. required = false).
					-- Without these, they only get the generic @lsp link and look wrong.
					hl("@lsp.type.annotationMember.java", light_blue)
					hl("@lsp.typemod.annotationMember.abstract.java", light_blue)
					hl("@lsp.typemod.annotationMember.public.java", light_blue)

					-- Classes, Interfaces, Enums, Records
					hl("@type", teal)
					hl("@lsp.type.class.java", teal)
					hl("@lsp.type.interface.java", teal)
					hl("@lsp.type.enum.java", teal)
					hl("@lsp.type.record.java", teal)
					hl("@lsp.typemod.record.importDeclaration.java", teal)
					hl("@lsp.typemod.record.public.java", teal)
					hl("@lsp.typemod.record.readonly.java", teal)

					-- Record header components (e.g. String senha in record R(String senha) {})
					hl("@lsp.type.recordComponent.java", light_blue)
					hl("@lsp.typemod.recordComponent.declaration.java", light_blue)

					-- Primitive types ('int', 'boolean', 'void') -> Green (Teal)
					hl("@type.builtin", teal)
					hl("javaType", teal)

					-- Basic modifiers ('public', 'private', 'static') -> Blue
					hl("@keyword.modifier.java", blue)
					hl("javaModifier", blue)

					-- Methods & Method Calls (executar, builder, stream)
					hl("@function.method", yellow)
					hl("@function.method.call", yellow)
					hl("@function.call", yellow)
					hl("@lsp.type.method.java", yellow)
					hl("javaMethodDecl", yellow)
					hl("javaMethodString", yellow)

					-- Variables and Properties
					hl("@variable", light_blue)
					hl("@lsp.type.variable.java", light_blue)
					hl("@lsp.type.parameter.java", light_blue)
					hl("@lsp.type.property.java", light_blue)
					hl("javaIdentifier", light_blue)
				end,
			})
		end
	},

	-- ── Lualine (statusline) ──────────────────────────────────
	{
		'nvim-lualine/lualine.nvim',
		event = 'VeryLazy',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				theme = 'vscode',
				globalstatus = true,
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { { 'filename', path = 1 } },
				lualine_x = {
					{
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if #clients == 0 then return '' end
							local names = {}
							for _, c in ipairs(clients) do
								table.insert(names, c.name)
							end
							return ' ' .. table.concat(names, ', ')
						end,
					},
				},
				lualine_y = { 'filetype', 'progress' },
				lualine_z = { 'location' },
			},
		},
	},

	-- ── Which-key (keymap hints) ──────────────────────────────
	-- {
	-- 	'folke/which-key.nvim',
	-- 	event = 'VeryLazy',
	-- 	opts = {
	-- 		plugins = { spelling = { enabled = true } },
	-- 	},
	-- 	config = function(_, opts)
	-- 		local wk = require('which-key')
	-- 		wk.setup(opts)
	-- 		wk.add({
	-- 			{ '<leader>c', group = 'Code' },
	-- 			{ '<leader>d', group = 'Debug' },
	-- 			{ '<leader>f', group = 'Find' },
	-- 			{ '<leader>g', group = 'Git' },
	-- 			{ '<leader>m', group = 'Minimap' },
	-- 			{ '<leader>t', group = 'Toggle' },
	-- 			{ '<leader>x', group = 'Trouble' },
	-- 		})
	-- 	end,
	-- },

	-- ── Indent guides ────────────────────────────────────────
	{
		'lukas-reineke/indent-blankline.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		main = 'ibl',
		opts = {
			indent = { char = '▏' },
			scope = { enabled = false, show_start = true },
			exclude = {
				filetypes = {
					'help', 'lazy', 'mason', 'neo-tree', 'trouble',
					'Trouble', 'checkhealth',
				},
			},
		},
	},

	{
		'LucasGualtieri/mini.indentscope',
		version = '*',

		config = function()
			local indent = require("mini.indentscope")

			indent.setup({

				symbol = '▏',

				draw = {
					-- Delay (in ms) between event and start of drawing scope indicator
					delay = 0,
					animation = indent.gen_animation.none(),

				},

				options = {
					border = 'both',
					indent_at_cursor = false,
					try_as_border = true
				},
			})
		end,
	},

	-- ── Devicons ──────────────────────────────────────────────
	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
	},

	-- ── Dressing (better vim.ui) ──────────────────────────────
	{
		'stevearc/dressing.nvim',
		event = 'VeryLazy',
		opts = {
			input = { enabled = true },
			select = { enabled = true },
		},
	},
}
