local map = vim.keymap.set

vim.g.mapleader = " "

map("n", "<leader><leader>", function()

    if vim.wo.relativenumber == true then
        vim.wo.relativenumber = false
        vim.wo.number = true
    else
        vim.wo.relativenumber = true
        vim.wo.number = true
    end
end)

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.api.nvim_set_keymap('n', '<S-A-f>', ':call VSCodeNotify("workbench.action.quickOpen")<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<leader>ff', ':call VSCodeNotify("find-it-faster.findFiles")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>fw', ':call VSCodeNotify("find-it-faster.findWithinFiles")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>fz', ':call VSCodeNotify("find-it-faster.findFilesWithType")<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ca', ':call VSCodeNotify("editor.action.quickFix")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sa', ':call VSCodeNotify("editor.action.sourceAction")<CR>', { noremap = true, silent = true })

map("n", "<C-a>", "<cmd>normal! ggVG<CR>", { desc = "select whole file" })

-- map("n", "<leader><leader>", function() vim.cmd("so") end)

map("n", "<BS>", "a<BS><Esc>")
map("n", "<Enter>", "a<Enter><Esc>")

-- Opens a "menu" that allows for replace all occurences of the word under the cursor
-- map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- These allow search terms to stay in the middle when "scrolling"
-- map("n", "n", "nzzzv")
-- map("n", "N", "Nzzzv")

-- These allow me to not override the buffer when pasting pasting or deleting
map("x", "<leader>p", "\"_dP")
map({"n", "v"}, "<leader>d", "\"_d") -- [["_d]]
map("n", "<leader>ciw", "\"_ciw")
map({"n", "v"}, "<leader>y", [["+y]])

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("n", "J", "mzJ`z", { desc = "Concat Holds the cursor when concatenating lines" })