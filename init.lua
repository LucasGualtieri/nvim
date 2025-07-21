require("config.lazy")
require("config")

vim.g.have_nerd_font = true

if vim.g.vscode then
	print("Running in VSCode")
    -- VSCode extension
else
    -- ordinary Neovim
	print("Running in Neovim")
end

-- vim.opt.sessionoptions:append("folds")

-- local visual_highlight = require('my_plugins.visual-highlight')
-- visual_highlight.setup()
