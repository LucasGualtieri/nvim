return {

	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',
	branch = '0.1.x',

	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-ui-select.nvim' },
		{ 'nvim-tree/nvim-web-devicons', enabled = true },
		{
			'nvim-telescope/telescope-fzf-native.nvim', build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end
		},
	},

	config = function()

		require('telescope').setup {
			-- pickers = {
			-- 	colorscheme = {
			-- 		enable_preview = true,  -- This enables the preview functionality
			-- 	},
			-- },
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
			},
		}

		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')

		local builtin = require 'telescope.builtin'

		vim.keymap.set('n', '<C-f>', function()
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false, })
		end, { desc = '[/] Fuzzily search in current buffer' })

		vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Telescope Git find files' })
		vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Telescope live grep' })
		-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

		-- vim.keymap.set('n', '<leader>s/', function()
		-- 	builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files', }
		-- end, { desc = '[S]earch [/] in Open Files' })
		--
		-- vim.keymap.set('n', '<leader>sn', function()
		-- 	builtin.find_files { cwd = vim.fn.stdpath 'config' }
		-- end, { desc = '[S]earch [N]eovim files' })

	end,
}
