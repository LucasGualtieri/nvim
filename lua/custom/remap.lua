vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local map = vim.keymap.set
local options = { noremap = true, silent = true }

map("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/nvim/tmux-sessionizer<CR>", options)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Moves line Up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Moves line Down" })

map("v", "<S-A-k>", ":'<,'>t'><CR>gv", { desc = "Move Copies line Up" })
map("v", "<S-A-j>", ":'<,'>t-1<CR>gv", { desc = "Move Copies line Down" })

map("v", "<Tab>", ">gv", { desc = "Tab Moves the selected lines 1 tab forward." })
map("v", "<S-Tab>", "<gv", { desc = "Tab Moves the selected lines 1 tab backward." })

map("n", "J", "mzJ`z", { desc = "Concat Holds the cursor when concatenating lines" })

-- Keeps the cursor centered when moving half a page Up or Down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- These jump forwards and backwards on the jump list
map("n", "<C-i>", "<C-o>zz", options)
map("n", "<C-o>", "<C-i>zz", options)

-- These allow search terms to stay in the middle when "scrolling"
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- These allow search terms to stay in the middle when "scrolling"
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Really important buffer remaps

map('v', 'c', '"_c')

map({ "n", "v" }, "<leader>y", '"+y')
-- map({ "n", "v" }, "<leader>Y", '"+y')

map({ "n", "v" }, "<leader>d", '"_d')
-- map({ "n", "v" }, "<leader>D", '"_d')

map("n", "ciw", '"_ciw', options)
map("n", "<leader>ciw", "ciw")

map("x", "p", '"_dP')
map("x", "<leader>p", "p")

-- -----------------------------------------

map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

-- Function to toggle line numbers - No needed with NVChad
map("n", "<leader><leader>", function()
	if vim.wo.relativenumber == true then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
		vim.wo.number = true
	end
end)

map("n", "<leader><Tab>", function()
	vim.cmd("so")
	print "File sourced!"
end)

map({ "i", "n", "x" }, "<C-c>", "<Esc>")

map("n", "<C-s>", ":w<CR>", options)

map("n", "<BS>", "a<BS><Esc>")
map("n", "<Enter>", "a<Enter><Esc>")

-- map("n", "<leader>f", function()
-- 	vim.lsp.buf.format()
-- end

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Opens LazyGit" })

map("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- map("n", "<C-/>", "gcc")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<Leader>fl", "<cmd>lua vim.diagnostic.open_float()<CR>", options)

-- map("i", "<C-h>", "<Left>")
-- map("i", "<C-l>", "<Right>")
-- map("i", "<C-k>", "<Up>")
-- map("i", "<C-j>", "<Down>")
