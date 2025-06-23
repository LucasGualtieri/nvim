return {

	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		vim.cmd("colorscheme rose-pine")
	-- 		-- Setting Transparency
	-- 		-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- 		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 	end
	-- },

	-- {
	-- 	"Mofiqul/dracula.nvim",
	-- 	name = "dracula",
	-- 	config = function()
	-- 		vim.cmd("colorscheme dracula")
	-- 	end
	-- }
	
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
					Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
					["@keyword.operator"] = { fg = c.vscPink, bold = true },  -- color for `new` and `delete`
					["@keyword.directive"] = { fg = c.vscPink, bold = true },
					["@string.escape"] = { fg = "#D7BA7D", bold = true },
				}
			})

			-- load the theme without affecting devicon colors.
			vim.cmd.colorscheme "vscode"
			vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = "#707070", bold = true })
			vim.api.nvim_set_hl(0, '@lsp.type.operator.cpp', { link = '' })  -- Remove o highlight do operador semântico para sobrescrevermos a cor
			-- vim.api.nvim_set_hl(0, "Visual", { bg = "#264F78", fg = "NONE" })
		end
	},
}
