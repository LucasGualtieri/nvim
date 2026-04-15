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
				add          = { text = '┃' },
				change       = { text = '┃' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
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
				map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
				map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
				map('n', '<leader>hp', gs.preview_hunk_inline, 'Preview hunk')
				map('n', '<leader>ghp', gs.preview_hunk, 'Preview hunk')
				map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame popup (full)')

				-- map('v', '<leader>ghs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk (visual)')
				-- map('v', '<leader>ghr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk (visual)')
				-- map('n', '<leader>ghS', gs.stage_buffer, 'Stage buffer')
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

	-- Clickable VSCode-style inline buttons
	{
		"madmaxieee/unclash.nvim",
		event = "BufReadPost",
		config = function()
			require("unclash").setup({
				action_buttons = {
					enabled = true, -- Enable/disable action buttons above conflicts
				},
				annotations = {
					enabled = true, -- Enable/disable annotations (e.g. "(Current Change)")
				},
			})
		end,
	},

	-- 3-way diff panel mergetool
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {{
			"<leader>gd",
			function()
				-- get_current_view() is only set on the Diffview *tab*; from any other tab
				-- it was always nil, so this kept opening new Diffviews instead of closing.
				local api = vim.api
				local lib = require("diffview.lib")
				local diffview = require("diffview")

				if lib.get_current_view() then
					diffview.close()
					return
				end

				for _, view in ipairs(lib.views) do
					if view.tabpage and api.nvim_tabpage_is_valid(view.tabpage) then
						api.nvim_set_current_tabpage(view.tabpage)
						diffview.close()
						return
					end
				end

				vim.cmd.DiffviewOpen()
			end,
			desc = "Git: Toggle Diffview (working tree vs HEAD)",
		}},

		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
				view = {
					-- diff3_mixed: OURS | THEIRS on top, LOCAL (working tree) full width below — :h diffview-layouts
					merge_tool = {
						layout = "diff3_mixed",
						winbar_info = true,
						disable_diagnostics = false,
					},
				},
			})
		end,
	},
}
