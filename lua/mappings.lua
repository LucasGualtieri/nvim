-- require "nvchad.mappings" -- If anything ever breaks, I should probably check this file

local map = vim.keymap.set
-- local unmap = vim.api.nvim_del_keymap

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-a>", "<cmd>normal! ggVG<CR>", { desc = "select whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader><Tab>", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
	require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "lsp rename variable" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })
map("n", "<leader>gd", function()
	vim.lsp.buf.definition()
	vim.defer_fn(function()
		vim.cmd("normal! zz")
	end, 25)  -- delay in milliseconds
end, { desc = "lsp jump to definition" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
	require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
	require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader><Del>", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>;", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>;", "gc", { desc = "comment toggle", remap = true })

-- nvimtree
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "telescope find git files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "telescope find all files" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
	require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
	require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
	local config = { scope = {} }
	config.scope.exclude = { language = {}, node_type = {} }
	config.scope.include = { node_type = {} }
	local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

	if node then
		local start_row, _, end_row, _ = node:range()
		if start_row ~= end_row then
			vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
			vim.api.nvim_feedkeys("_", "n", true)
		end
	end
end, { desc = "blankline jump to current context" })

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

local options = { noremap = true, silent = true }

-- I have to study this a bit more
-- if vim.lsp.inlay_hint then
-- 	vim.keymap.set('n', '<leader>uh', function()
-- 		vim.lsp.inlay_hint(0, nil)
-- 	end, { desc = 'Toggle Inlay Hints' })
-- end

map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Moves line Up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Moves line Down" })

map("v", "<S-A-k>", ":'<,'>t'><CR>gv", { desc =  "Move Copies line Up" })
map("v", "<S-A-j>", ":'<,'>t-1<CR>gv", { desc =  "Move Copies line Down" })

map("v", "<Tab>", ">gv", { desc = "Tab Moves the selected lines 1 tab forward." })
map("v", "<S-Tab>", "<gv", { desc = "Tab Moves the selected lines 1 tab backward." })

map("n", "J", "mzJ`z", { desc = "Concat Holds the cursor when concatenating lines" })

-- Keeps the cursor centered when moving half a page Up or Down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Não consegui fazer esses dois funcionar
-- map("n", "<S-{>", "<S-{>zz")
-- map("n", "<S-}>", "<S-}>zz")

map("n", "<leader><leader>", function() vim.cmd("so") end)

map("n", "<BS>", "a<BS><Esc>")
map("n", "<Enter>", "a<Enter><Esc>")

map({"n", "v"}, "<leader>y", [["+y]])
map("n", "<leader>y", [["+y]])
-- map({"n", "v"}, "<leader>d", [["_d]])

map("i", "<C-c>", "<Esc>")
-- map("n", "<C-c>", "<Esc>")
-- map("x", "<C-c>", "<Esc>")

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Opens LazyGit" })

-- These jump forwards and backwards on the jump list
map('n', '<C-o>', '<C-o>zz', options)
map('n', '<C-p>', '<C-i>zz', options)

-- Opens a "menu" that allows for replace all occurences of the word under the cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Unmap y from copying to the system clipboard
map('n', 'y', '"+y', options)
map('v', 'y', '"+y', options)
map('n', 'Y', '"+Y', options)

-- Remap y to the default yank behavior
map('n', 'y', 'y', options)
map('v', 'y', 'y', options)
map('n', 'Y', 'Y', options)

-- These allow search terms to stay in the middle when "scrolling"
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- These allow me to not override the buffer when pasting pasting or deleting
map("x", "<leader>p", "\"_dP")
map("n", "<leader>d", "\"_dP")
map("v", "<leader>d", "\"_dP")

map("n", "<A-j>", "<cmd>cnext<CR>zz", { desc = "QuickFix Next file" })
map("n", "<A-k>", "<cmd>cprev<CR>zz", { desc = "QuickFix Previous file" })

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Function to toggle line numbers - No needed with NVChad
-- map("n", "<leader><Tab>", function()
--
-- 	if vim.wo.relativenumber == true then
-- 		vim.wo.relativenumber = false
-- 		vim.wo.number = true
-- 	else
-- 		vim.wo.relativenumber = true
-- 		vim.wo.number = true
-- 	end
-- end)

-- Not necessary with NVChad
-- vim.g.mapleader = " "
-- map("n", "<leader>pv", vim.cmd.Ex)

-- map("n", ";", ":", { desc = "CMD enter command mode" })

-- Not necessary with NVChad
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Not necessary with NVChad
-- map("i", "<C-h>", "<Left>")
-- map("i", "<C-l>", "<Right>")
-- map("i", "<C-k>", "<Up>")
-- map("i", "<C-j>", "<Down>")
-- map("i", "<C-b>", "<C-o>b")
-- map("i", "<C-Del>", "<C-o>dw")
-- map("i", "<C-BS>", "<Esc>dbi") -- É só usar o padrão control + w

-- Not sure if I should be using these with NVChad
-- vim.keymap.set("n", "Q", "<nop>")
-- map("n", "<leader>f", vim.lsp.buf.format)

-- Don't know what these are for
-- map("n", "<leader>k", "<cmd>lnext<CR>zz")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz")
