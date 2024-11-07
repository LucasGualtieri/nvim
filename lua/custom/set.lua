local opt = vim.opt
local o = vim.o
-- local g = vim.g

-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.laststatus = 3      -- Use a single global status line (good for custom status lines)
vim.opt.showmode = false    -- Disable default mode indicator

function ColorMyPencils(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils("dracula")

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
