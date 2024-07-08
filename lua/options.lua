require "nvchad.options"

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- This is necessary to separate Vim's "clipboard", to the system's.
vim.opt.clipboard = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- This set to true turn tabs into spaces

vim.opt.smartindent = true

-- vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")

-- vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
