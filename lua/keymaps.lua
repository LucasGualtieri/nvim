-- ╔══════════════════════════════════════════════════════════╗
-- ║  keymaps.lua — essential non-plugin keymaps             ║
-- ╚══════════════════════════════════════════════════════════╝
-- Plugin-specific keymaps live in their own plugin files.
-- These are general-purpose mappings that don't depend on any plugin.

local map = vim.keymap.set -- Shorthand to reduce repetition below

-- ── Window navigation ───────────────────────────────────────
-- Move between split windows without the two-key <C-w> prefix.
-- Instead of <C-w>h, just press <C-h> to jump to the left window.
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })   -- Ctrl+H → focus window to the left
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })  -- Ctrl+J → focus window below
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })  -- Ctrl+K → focus window above
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })  -- Ctrl+L → focus window to the right

-- Tmux sessionizer: needs a tmux client (`tmux popup`). Script was non-executable
-- before (exec failed silently with `silent !`); we run via `bash` and surface errors.
map('n', '<leader>f', function()
	if vim.env.TMUX == nil then
		vim.notify('tmux-sessionizer: start Neovim from inside tmux (TMUX is unset).', vim.log.levels.WARN)
		return
	end
	local script = vim.fs.joinpath(vim.fn.stdpath('config'), 'tmux-sessionizer')
	if vim.fn.filereadable(script) == 0 then
		vim.notify('tmux-sessionizer: missing ' .. script, vim.log.levels.ERROR)
		return
	end
	local cmd = 'tmux popup -E ' .. vim.fn.shellescape('bash ' .. script)
	local out = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify('tmux popup failed: ' .. vim.trim(out ~= '' and out or ('exit ' .. vim.v.shell_error)), vim.log.levels.ERROR)
	end
end, { desc = 'Tmux sessionizer (fzf projects)' })

-- ── Keep cursor centered ────────────────────────────────────
-- When scrolling half-pages or jumping between search results,
-- the screen re-centers so you never lose track of where you are.
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })   -- Half-page down + center cursor on screen
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })     -- Half-page up + center cursor on screen
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })  -- Next match + center + open any fold hiding it
map('n', 'N', 'Nzzzv', { desc = 'Prev search result (centered)' })  -- Prev match + center + open any fold hiding it

-- ── Clear search highlight ──────────────────────────────────
-- After searching, all matches stay highlighted (hlsearch). Press <Esc> to clear them.
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- ── Diagnostics (Neovim 0.12 API) ──────────────────────────
-- Uses the new vim.diagnostic.jump() API (replaces deprecated goto_next/goto_prev).
-- count=1 means jump forward, count=-1 means jump backward. float=true shows details.
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })   -- Jump to next warning/error
map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Prev diagnostic' })  -- Jump to previous warning/error

-- ── Join lines without moving cursor ────────────────────────
-- `mz` saves cursor position, J joins, backtick-z restores it so the cursor
-- stays on the original word instead of jumping to the end of the joined line.
map('n', 'J', 'mzJ`z', { desc = 'Join line (cursor stays)' })

-- ── Toggle relative line numbers ─────────────────────────────
map('n', '<leader><leader>', function()
	local rn = vim.wo.relativenumber
	vim.wo.relativenumber = not rn
	vim.wo.number = true
	vim.notify('Relative numbers ' .. (not rn and 'enabled!' or 'disabled!'), vim.log.levels.INFO)
end, { desc = 'Toggle relative line numbers' })

-- ── Jump list with centering ─────────────────────────────────
-- <C-o> jumps backward and <C-i> forward in the jump list; zz centers after each.
map('n', '<C-o>', '<C-i>zz', { desc = 'Jump backward (centered)' })
map('n', '<C-i>', '<C-o>zz', { desc = 'Jump forward (centered)' })

-- ── Ctrl+C / backspace / return / Q ─────────────────────────
-- <C-c> as <Esc> (in n/i/x: normal-mode <Esc> still runs nohlsearch above).
map({ 'i', 'n', 'x' }, '<C-c>', '<Esc>', { desc = 'Escape' })
-- Normal-mode: append, delete newline or insert newline, return to normal.
map('n', '<BS>', 'a<BS><Esc>', { desc = 'Delete char under cursor (via append)' })
map('n', '<CR>', 'a<CR><Esc>', { desc = 'Insert newline (via append)' })
map('n', 'Q', '<Nop>', { desc = 'Disable ex mode' })

-- ── Save, notify, trim trailing whitespace (mini.trailspace) ─
map('n', '<C-s>', function()
	vim.cmd.write()
	vim.notify('File saved!', vim.log.levels.INFO)
	if vim.bo.filetype ~= 'oil' then
		local ok, trailspace = pcall(require, 'mini.trailspace')
		if ok then
			trailspace.trim_last_lines()
			trailspace.trim()
		end
	end
end, { desc = 'Save file and notify' })

map('n', '<leader>rq', function()
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	require('telescope.builtin').live_grep({
		prompt_title = 'Live grep — ⌃Q → quickfix → replace',
		attach_mappings = function(prompt_bufnr, map)
			local function send_qf_then_replace()
				local search = action_state.get_current_line()
				if search == '' then
					vim.notify('live_grep: type a pattern first, then ⌃Q', vim.log.levels.WARN)
					return
				end
				actions.send_to_qflist(prompt_bufnr)
				actions.open_qflist(prompt_bufnr)
				vim.schedule(function()
					local replace = vim.fn.input('Replace "' .. search .. '" with: ')
					if replace == '' then return end
					vim.cmd(string.format(
						'cfdo %%s#%s#%s#gc | update',
						vim.fn.escape(search, '#'),
						vim.fn.escape(replace, '#')
					))
				end)
			end
			map('i', '<C-q>', send_qf_then_replace)
			map('n', '<C-q>', send_qf_then_replace)
			return true
		end,
	})
end, { desc = 'Telescope live_grep → ⌃Q → cfdo replace' })
