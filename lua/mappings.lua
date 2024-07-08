require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.api.nvim_del_keymap
local options = { noremap = true, silent = true }

-- Not necessary with NVChad
-- vim.g.mapleader = " "
-- map("n", "<leader>pv", vim.cmd.Ex)

map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Enables saving with control + s
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Moves line UP
map("v", "K", ":m '<-2<CR>gv=gv")
-- Moves line Down
map("v", "J", ":m '>+1<CR>gv=gv")

-- Copies line UP
map("v", "<S-A-k>", ":'<,'>t'><CR>gv")
-- Copies line Down
map("v", "<S-A-j>", ":'<,'>t-1<CR>gv")

-- Function to toggle line numbering
map("n", "<leader><Tab>", function()

	if vim.wo.relativenumber == true then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
		vim.wo.number = true
	end
end)

-- Keeps the cursor when using shift + j to concatenate lines
map("n", "J", "mzJ`z")

-- Keeps the cursor centered when moving half a page Up or Down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Don't know what these are for
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Not necessary with NVChad
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

map("n", "<leader><leader>", function() vim.cmd("so") end)

-- Not necessary with NVChad
-- map("i", "<C-h>", "<Left>")
-- map("i", "<C-l>", "<Right>")
-- map("i", "<C-k>", "<Up>")
-- map("i", "<C-j>", "<Down>")
map("i", "<C-b>", "<C-o>b")
map("i", "<C-Del>", "<C-o>dw")
-- map("i", "<C-BS>", "<Esc>dbi") -- Não consegui fazer funcionar

map("n", "<BS>", "a<BS><Esc>")
map("n", "<Enter>", "a<Enter><Esc>")
-- map("n", "<Del>", "x") -- I think this is native behavior

map({"n", "v"}, "<leader>y", [["+y]])
map("n", "<leader>y", [["+y]])

-- Unmap y from copying to the system clipboard
map('n', 'y', '"+y', options)
map('v', 'y', '"+y', options)
map('n', 'Y', '"+Y', options)

-- Remap y to the default yank behavior
map('n', 'y', 'y', options)
map('v', 'y', 'y', options)
map('n', 'Y', 'Y', options)

-- Not sure what this does
-- map({"n", "v"}, "<leader>d", [["_d]])

map("i", "<C-c>", "<Esc>")

-- Not sure if I should be using these with NVChad
-- vim.keymap.set("n", "Q", "<nop>")
-- map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- map("n", "<leader>f", vim.lsp.buf.format)

unmap("n", "<C-n>") -- Unbining NVChad's native behavior to open up the file trees
-- map('x', '<C-c>', '<Esc>', options)
-- map('n', '<C-b>', '<Plug>(VM-Find-Subword-Under)', options)
-- map('v', '<C-b>', '<Plug>(VM-Find-Subword-Under)', options)
-- map('i', '<C-b>', '<Plug>(VM-Find-Subword-Under)', options)

-- map("n", "<C-k>", "<cmd>cnext<CR>zz")
-- map("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Don't know what these are for
-- map("n", "<leader>k", "<cmd>lnext<CR>zz")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Opens a "menu" that allows for replace all occurences of the word under the cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
