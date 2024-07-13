require "nvchad.options"

local opt = vim.opt
local o = vim.o
-- local g = vim.g

o.cursorlineopt ='both' -- to enable cursorline!

-- This is necessary to separate Vim's "clipboard", to the system's.
opt.clipboard = ""

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

-- Don't know if I should keep these one
opt.hlsearch = false
opt.incsearch = true

-- opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
-- opt.isfname:append("@-@")

-- opt.updatetime = 50

-- opt.colorcolumn = "80"
