-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/explorer.lua — oil.nvim + neo-tree             ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── Oil (directory editor / netrw replacement) ────────────
	{
		'stevearc/oil.nvim',
		lazy = false, -- critical: replaces netrw as default directory opener
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ '-', '<cmd>Oil<CR>',               desc = 'Oil: Open parent directory' },
			{ '<leader>o', '<cmd>Oil --float<CR>', desc = 'Oil: Open float' },
		},
		opts = {
			default_file_explorer = true,
			-- Explicit maps (same as oil.nvim defaults; see :help oil-actions).
			use_default_keymaps = false,
			keymaps = {
				-- ['g?'] = { 'actions.show_help', mode = 'n' },
				['<CR>'] = 'actions.select',
				-- ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
				-- ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
				-- ['<C-t>'] = { 'actions.select', opts = { tab = true } },
				-- ['<C-p>'] = 'actions.preview',
				-- ['<C-c>'] = { 'actions.close', mode = 'n' },
				-- ['<C-l>'] = 'actions.refresh',
				['-'] = { 'actions.parent', mode = 'n' },
				['_'] = { 'actions.open_cwd', mode = 'n' },
				['`'] = { 'actions.cd', mode = 'n' },
				['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
				['gs'] = { 'actions.change_sort', mode = 'n' },
				['gx'] = 'actions.open_external',
				['g.'] = { 'actions.toggle_hidden', mode = 'n' },
				['g\\'] = { 'actions.toggle_trash', mode = 'n' },
			},
			view_options = { show_hidden = true },
			float = { padding = 2 },
			lsp_file_methods = { autosave_changes = true },
		},
	},

	-- ── Neo-tree (sidebar explorer) ───────────────────────────
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		cmd = 'Neotree',
		keys = {
			{ '<leader>e', '<cmd>Neotree toggle filesystem<CR>',   desc = 'Neo-tree: Toggle filesystem' },
			{ '<leader>E', '<cmd>Neotree toggle git_status<CR>',   desc = 'Neo-tree: Toggle git status' },
		},
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},
		opts = {
			sources = { 'filesystem', 'buffers', 'git_status' },
			filesystem = {
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				width = 35,
				mappings = {
					['<space>'] = 'none', -- avoid conflict with leader
				},
			},
		},
	},
}
