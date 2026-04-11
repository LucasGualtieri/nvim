-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/telescope.lua — fuzzy finder                   ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		keys = {
			{ '<leader>pf', '<cmd>Telescope find_files<CR>',                    desc = 'Telescope: Find all files' },
			{ '<leader>fd', '<cmd>Telescope diagnostics<CR>',                   desc = 'Telescope: Diagnostics' },
			{ '<leader>pg', '<cmd>Telescope live_grep<CR>',                     desc = 'Telescope: Live grep' },
			{ '<leader>fg', '<cmd>Telescope git_files<CR>',                     desc = 'Telescope: Find Git files' },
			{
				'<C-f>',
				function()
					require('telescope.builtin').current_buffer_fuzzy_find(
						require('telescope.themes').get_dropdown({ winblend = 10, previewer = false })
					)
				end,
				desc = '[/] Fuzzily search in current buffer',
			},
			-- -------------------------------------------------------------------------------------------------------------
			-- { '<leader>fb', '<cmd>Telescope buffers<CR>',                       desc = 'Telescope: Buffers' },
			-- { '<leader>fh', '<cmd>Telescope help_tags<CR>',                     desc = 'Telescope: Help tags' },
			-- { '<leader>fr', '<cmd>Telescope oldfiles<CR>',                      desc = 'Telescope: Recent files' },
			-- { '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>',          desc = 'Telescope: Document symbols' },
			-- { '<leader>fS', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Telescope: Workspace symbols' },
		},

		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			},
		},
		config = function()
			local telescope = require('telescope')
			telescope.setup({
				defaults = {
					path_display = { 'filename_first' }, -- Show filename before the path (great for deeply nested projects)
					layout_strategy = 'horizontal',
					sorting_strategy = 'ascending',
					winblend = 0,
					layout_config = {
						horizontal = {
							prompt_position = 'top',
							width = 0.9, -- Wider window so long paths don't get truncated
							preview_width = 0.5, -- Give equal space to the file list and the preview
						},
					},
				},
			})
			telescope.load_extension('fzf')
		end,
	},
}
