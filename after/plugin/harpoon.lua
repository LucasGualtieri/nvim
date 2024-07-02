local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-j>", ui.toggle_quick_menu)

local current_file_index = 0

local function nav_file(index)
    current_file_index = index
    print("current_file_index", current_file_index)
    ui.nav_file(index)
end

local function cycleForward()
    if current_file_index >= mark.get_length() then return 1 else return current_file_index + 1 end
end

local function cycleBackwards()
    if current_file_index == 1 then return mark.get_length() else return current_file_index - 1 end
end

vim.keymap.set("n", "<leader>1", function() nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() nav_file(cycleForward()) end)
vim.keymap.set("n", "<C-s>", function() nav_file(cycleBackwards()) end)
