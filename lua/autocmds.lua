-- ╔══════════════════════════════════════════════════════════╗
-- ║  autocmds.lua — autocommands                           ║
-- ╚══════════════════════════════════════════════════════════╝
-- Autocommands run code automatically when specific events occur
-- (e.g., opening a file, saving, yanking text). Each one is placed
-- in a named augroup with clear=true so reloading this file doesn't
-- create duplicate autocommands.

local autocmd = vim.api.nvim_create_autocmd -- Shorthand for creating autocommands
local augroup = vim.api.nvim_create_augroup -- Shorthand for creating autocommand groups

-- ── Highlight on yank ───────────────────────────────────────
-- Briefly flashes the yanked (copied) text so you can see exactly
-- what was captured. Uses the IncSearch highlight group for the flash.
autocmd('TextYankPost', {                                 -- Fires after any yank/copy operation
	group = augroup('HighlightYank', { clear = true }),   -- Group name; clear=true prevents duplicates on re-source
	callback = function()
		vim.hl.on_yank({ higroup = 'IncSearch', timeout = 50 }) -- Flash the yanked region for 150ms using IncSearch colors
	end,
})

-- ── Restore cursor position on file open ────────────────────
-- When you reopen a file, the cursor jumps back to where you left off
-- instead of starting at line 1. Uses the '" mark that Neovim stores automatically.
autocmd('BufReadPost', {                                        -- Fires after reading a file into a buffer
  group = augroup('RestoreCursor', { clear = true }),           -- Prevents duplicate autocmds
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')      -- Get the '" mark (last cursor position in this file)
    local line_count = vim.api.nvim_buf_line_count(args.buf)    -- Total number of lines in the buffer
    if mark[1] > 0 and mark[1] <= line_count then               -- Only restore if the mark is within valid range
      pcall(vim.api.nvim_win_set_cursor, 0, mark)              -- pcall protects against edge cases (e.g., deleted lines)
    end
  end,
})

-- ── Disable auto-comment on new line ────────────────────────
-- By default, Vim continues comment syntax when you press 'o' or Enter
-- inside a comment block. This removes that behavior so new lines start clean.
-- autocmd('FileType', {                                           -- Fires when a buffer's filetype is detected
--   group = augroup('FormatOptions', { clear = true }),           -- Prevents duplicate autocmds
--   callback = function()
--     vim.opt_local.formatoptions:remove({ 'o', 'r' })           -- 'o': don't auto-comment on 'o'/'O'; 'r': don't auto-comment on Enter
--   end,
-- })

-- ── Close certain windows with 'q' ─────────────────────────
-- In helper windows (help pages, quickfix, plugin panels), pressing 'q'
-- closes the window immediately instead of requiring :q or :close.
autocmd('FileType', {                             -- Fires when a buffer's filetype is detected
	group = augroup('QuickClose', { clear = true }), -- Prevents duplicate autocmds
	pattern = {                                   -- List of filetypes that get the quick-close behavior:
		'help',                                   -- :help pages
		'qf',                                     -- Quickfix list (:copen)
		'lspinfo',                                -- :LspInfo window
		'man',                                    -- :Man pages
		'checkhealth',                            -- :checkhealth results
		'trouble',                                -- Trouble.nvim diagnostics panel
		'DiffviewFiles',                          -- Diffview file panel
		'NeogitStatus',                           -- Neogit status buffer
		'neo-tree',                               -- Neo-tree file explorer
	},
	callback = function(args)
		vim.bo[args.buf].buflisted = false     -- Hide this buffer from the buffer list (:ls) so it doesn't clutter navigation
		vim.keymap.set('n', 'q', '<cmd>close<CR>', { -- Map 'q' to close the window (buffer-local only)
			buffer = args.buf,                 -- Only applies to this specific buffer
			silent = true,                     -- Don't echo the command in the command line
			desc = 'Close window',             -- Description shown in which-key
		})
	end,
})

-- ── Auto-quit on orphaned RPC ──────────────────────────────
-- If launched via --embed (UI detached) and the UI connection drops,
-- force Neovim to quit to prevent ghost processes from eating RAM.
-- autocmd('UILeave', {
-- 	group = augroup('OrphanedRPCQuit', { clear = true }),
-- 	callback = function()
-- 		if #vim.api.nvim_list_uis() == 0 then
-- 			vim.cmd([[qa!]])
-- 		end
-- 	end,
-- })
