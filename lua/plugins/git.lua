-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/git.lua — gitsigns, neogit, diffview           ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── Gitsigns ──────────────────────────────────────────────
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			signs = {
				add          = { text = '│' },
				change       = { text = '│' },
				delete       = { text = '' },
				topdelete    = { text = '' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			current_line_blame = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'Git: ' .. desc })
				end

				-- Navigation
				map('n', ']h', function() gs.nav_hunk('next') end, 'Next hunk')
				map('n', '[h', function() gs.nav_hunk('prev') end, 'Prev hunk')

				-- Actions
				map('n', '<leader>ghs', gs.stage_hunk, 'Stage hunk')
				map('n', '<leader>ghr', gs.reset_hunk, 'Reset hunk')
				map('v', '<leader>ghs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk (visual)')
				map('v', '<leader>ghr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk (visual)')
				map('n', '<leader>ghS', gs.stage_buffer, 'Stage buffer')
				map('n', '<leader>ghp', gs.preview_hunk, 'Preview hunk')
				map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame popup (full)')
			end,
		},
	},

	-- ── Neogit ────────────────────────────────────────────────
	{
		'NeogitOrg/neogit',
		cmd = 'Neogit',
		keys = {
			{ '<leader>gg', '<cmd>Neogit<CR>', desc = 'Git: Open Neogit' },
		},
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
		},
		opts = {
			integrations = { diffview = true },
			kind = 'tab',
		},
	},

	-- ── Diffview ──────────────────────────────────────────────
	{
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
		keys = {
			{ '<leader>gd', '<cmd>DiffviewOpen<CR>',              desc = 'Git: Diffview (working tree vs HEAD)' },
			{ '<leader>gc', '<cmd>DiffviewClose<CR>',             desc = 'Git: Close Diffview' },
			{ '<leader>gh', '<cmd>DiffviewFileHistory %<CR>',     desc = 'Git: File history (current)' },
			{ '<leader>gH', '<cmd>DiffviewFileHistory<CR>',       desc = 'Git: Repo history' },
		},
		opts = {},
	},
}
