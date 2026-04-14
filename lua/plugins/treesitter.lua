-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/treesitter.lua — syntax + text objects         ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── Treesitter ────────────────────────────────────────────
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = { 'BufReadPost', 'BufNewFile' },
		---@type TSConfig
		opts = {
			ensure_installed = {
				'lua', 'python', 'typescript', 'javascript', 'tsx',
				'java', 'c', 'cpp', 'bash', 'json', 'yaml', 'toml',
				'markdown', 'markdown_inline', 'html', 'css',
			},
			highlight = { enable = true },
			indent = { enable = true },
			-- NOTE: incremental_selection is NOT configured here —
			-- Neovim 0.12 provides it as built-in (v_an, v_in)
		},
		config = function(_, opts)
			require('nvim-treesitter').setup(opts)

			-- nvim-treesitter no longer turns on highlight; queries live in the plugin but
			-- Neovim only draws TS highlights after |vim.treesitter.start()| (see plugin README).
			-- Without it, |vim.treesitter.highlighter.active[buf]| is nil, |:Inspect| shows no
			-- Treesitter captures, and regex |syntax| may still be cleared if something else
			-- attached a highlighter briefly.
			local group = vim.api.nvim_create_augroup('nvim-config.treesitter-start', { clear = true })
			local function try_start(bufnr)
				bufnr = vim._resolve_bufnr(bufnr)
				if vim.treesitter.highlighter.active[bufnr] then
					return
				end
				pcall(vim.treesitter.start, bufnr)
			end

			vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost', 'BufNewFile' }, {
				group = group,
				callback = function(args)
					try_start(args.buf)
				end,
			})

			-- Lazy may load this plugin after FileType/BufReadPost already ran for the current buffer.
			try_start(0)
		end,
	},

	-- ── Treesitter text objects ───────────────────────────────
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		event = { 'BufReadPost', 'BufNewFile' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			-- In modern nvim-treesitter, textobjects are configured
			-- via the vim.treesitter API or direct keymap setup
			local ts_repeat_move = nil
			pcall(function()
				ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
			end)

			-- Select text objects
			local select_ok, ts_select = pcall(require, 'nvim-treesitter.textobjects.select')
			if select_ok then
				ts_select.setup({
					enable = true,
					lookahead = true,
					keymaps = {
						['af'] = { query = '@function.outer', desc = 'Select outer function' },
						['if'] = { query = '@function.inner', desc = 'Select inner function' },
						['ac'] = { query = '@class.outer', desc = 'Select outer class' },
						['ic'] = { query = '@class.inner', desc = 'Select inner class' },
						['aa'] = { query = '@parameter.outer', desc = 'Select outer argument' },
						['ia'] = { query = '@parameter.inner', desc = 'Select inner argument' },
					},
				})
			end

			-- Move between text objects
			local move_ok, ts_move = pcall(require, 'nvim-treesitter.textobjects.move')
			if move_ok then
				ts_move.setup({
					enable = true,
					set_jumps = true,
					goto_next_start = {
						[']f'] = { query = '@function.outer', desc = 'Next function start' },
						[']c'] = { query = '@class.outer', desc = 'Next class start' },
					},
					goto_previous_start = {
						['[f'] = { query = '@function.outer', desc = 'Prev function start' },
						['[c'] = { query = '@class.outer', desc = 'Prev class start' },
					},
				})
			end
		end,
	},
}
