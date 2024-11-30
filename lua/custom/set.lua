local opt = vim.opt
local o = vim.o
-- local g = vim.g

-- vim.opt.list = true
-- vim.opt.listchars:append({
--     trail = '·', -- Show trailing spaces as '·'
--     nbsp = '␣',  -- Show non-breaking spaces
-- 	-- tab = '| ', -- Show tabs as '| '
-- })

-- These two are for flash.lua
-- Make search case insensitive
vim.opt.ignorecase = true   -- Ignore case in search patterns
vim.opt.smartcase = true    -- Override ignorecase if search pattern contains uppercase letters

vim.opt.laststatus = 3      -- Use a single global status line (good for custom status lines)
vim.opt.showmode = false    -- Disable default mode indicator

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "" },
	callback = function()
		vim.opt_local.commentstring = "// %s"
	end,
})

-- Automatically save folds when exiting
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*",
	command = "silent! mkview",
})

-- Automatically load folds when opening
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	command = "silent! loadview",
})

-- function ColorMyPencils(color)
-- 	color = color or "dracula"
-- 	vim.cmd.colorscheme(color)
--
-- 	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end

-- ColorMyPencils("dracula")

o.cursorlineopt = "both" -- to enable cursorline!

-- This is necessary to separate Vim's "clipboard", to the system's.
opt.clipboard = "unnamedplus"

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false -- This set to true turn tabs into spaces

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Don't know if I should keep these ones
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes" -- The column to the left of the line numbers
-- opt.isfname:append("@-@")

-- opt.updatetime = 50

-- opt.colorcolumn = "80"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})
