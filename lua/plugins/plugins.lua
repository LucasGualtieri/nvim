local plugins = {

	{
		"nvim-telescope/telescope.nvim",

		opts = function()

			local conf = require "nvchad.configs.telescope"

			conf.defaults.mappings.i = {
				["<C-k>"] = require("telescope.actions").move_selection_previous,
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<Esc>"] = require("telescope.actions").close,
			}

			return conf
		end,
	},

	{ "tpope/vim-fugitive", lazy = false },

	{ "nvim-treesitter/nvim-treesitter-context", lazy = false },

	{ "kdheepak/lazygit.nvim", lazy = false },

	{ "ThePrimeagen/vim-be-good", lazy = false },

	{
		"mbbill/undotree",
		lazy = false,

		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,

		config = function()

			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
			vim.keymap.set("n", "<C-g>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

			vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end)

			-- Navigate through list with arrow keys
			vim.keymap.set("n", "<C-Right>", function() harpoon:list():next() end)
			vim.keymap.set("n", "<C-Left>", function() harpoon:list():prev() end)
		end
	},

	{
		"mg979/vim-visual-multi",
		branch = "master",
		lazy = false,
		-- event = 'VimEnter',
	},

	{
		"folke/zen-mode.nvim",
		lazy = false,

		config = function()
			vim.keymap.set("n", "<leader>zz", function()
				require("zen-mode").setup {
					window = {
						width = 120,
						options = { }
					},
				}
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.rnu = true
				-- ColorMyPencils()
			end)

			vim.keymap.set("n", "<leader>zZ", function()
				require("zen-mode").setup {
					window = {
						width = 80,
						options = { }
					},
				}
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.rnu = true
				-- ColorMyPencils()
			end)
		end
	}

	-- Haven't yet found a way to make this work
	-- {
	--        "rockyzhang24/arctic.nvim",
	--        dependencies = { "rktjmp/lush.nvim" },
	--        name = "arctic",
	--        branch = "v2",
	--        -- priority = 1000,
	--        config = function()
	--            vim.cmd("colorscheme arctic")
	--        end
	--    },
}

return plugins
