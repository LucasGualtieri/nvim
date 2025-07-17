vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local map = vim.keymap.set
local options = { noremap = true, silent = true }

-- map("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/nvim/tmux-sessionizer<CR>", options)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- map("v", "K", ":m '<-2<cr>gv=gv", { desc = "move moves line up" })
-- map("v", "J", ":m '>+1<cr>gv=gv", { desc = "move moves line down" })

-- map("v", "<Tab>", ">gv", { desc = "Tab Moves the selected lines 1 tab forward." })
-- map("v", "<S-Tab>", "<gv", { desc = "Tab Moves the selected lines 1 tab backward." })

-- map('n', '<C-S-K>', '<C-y>', options)
-- map('n', '<C-S-J>', '<C-e>', options)

map("v", "<S-A-K>", ":'<,'>t'><CR>gv", { desc = "Copy selection up" })
map("v", "<S-A-J>", ":'<,'>t-1<CR>gv", { desc = "Copy selection down" })

map("n", "J", "mzJ`z", { desc = "Concat Holds the cursor when concatenating lines" })

-- Keeps the cursor centered when moving half a page Up or Down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- These allow search terms to stay in the middle when "scrolling"
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- These jump forwards and backwards on the jump list
map("n", "<C-i>", "<C-o>zz", options)
map("n", "<C-o>", "<C-i>zz", options)

-- Really important buffer remaps

map({ "n", "v" }, "<leader>y", '"+y')
-- map({ "n", "v" }, "<leader>Y", '"+y')

map({ "n", "v" }, "<leader>d", '"_d')
-- map({ "n", "v" }, "<leader>D", '"_d')

map('v', 'c', '"_c')
map("n", "ciw", '"_ciw', options)
map("x", "p", '"_dP')

-- map("x", "<leader>p", "p")
-- map("n", "<leader>ciw", "ciw")

-- -----------------------------------------

-- This is for ctrl+c to apply visual block mode changes
map({ "i", "n", "x" }, "<C-c>", "<Esc>")
map("n", "Q", "<nop>")

-- map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

-- Function to toggle line numbers - No needed with NVChad
vim.keymap.set("n", "<leader><leader>", function()
	local rn = vim.wo.relativenumber
	vim.wo.relativenumber = not rn
	vim.wo.number = true
	vim.notify("Relative numbers " .. (not rn and "enabled!" or "disabled!"), vim.log.levels.INFO)
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader><Tab>", function()
	if vim.bo.filetype == "lua" then
		vim.cmd.source()
		vim.notify("Lua file sourced!", vim.log.levels.INFO)
	else
		vim.notify("Not a Lua file. Source skipped.", vim.log.levels.WARN)
	end
end, { desc = "Source Lua file" })

vim.keymap.set(
	"n", "<C-s>",
	function()
		vim.cmd.write()
		vim.notify("File saved!", vim.log.levels.INFO)
		if vim.bo.filetype ~= 'oil' then
			MiniTrailspace.trim_last_lines()
			MiniTrailspace.trim()
		end
	end,
	{ desc = "Save file and notify" }
)

-- NOTE: These conflict with the snippets 'next'
-- map("i", "<C-h>", "<Left>")
-- map("i", "<C-l>", "<Right>")
-- map("i", "<C-k>", "<Up>")
-- map("i", "<C-j>", "<Down>")

-- Quickfix navigation
-- NOTE: Me questiono se isso é necessário, assumindo que vou conseguir usar bem o trouble para navegação de quickfix list
-- Esse comando em tese é comportamento padrão, mas não estava funcionando.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		-- Map <CR> para abrir o item da quickfix corretamente
		vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
	end,
})

vim.keymap.set("n", "<S-M-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-M-k>", "<cmd>cprev<CR>zz")

-- Location list navigation
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<BS>", "a<BS><Esc>")
map("n", "<Enter>", "a<Enter><Esc>")

-- map("n", "<leader>f", function()
	-- 	vim.lsp.buf.format()
	-- end

	-- map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Opens LazyGit" })

	-- map("n", "<leader>zig", "<cmd>LspRestart<cr>")

	-- map("n", "<C-/>", "gcc")

	-- map("n", "<Leader>fl", "<cmd>lua vim.diagnostic.open_float()<CR>", options)

	-- map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	-- map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	-- map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	-- map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- TODO:
	-- Comments should workd like in VSCode
	-- Blank lines should NOT be commented out
	-- The selection of commented and uncommented lined should "swap" the comment, not comment both
