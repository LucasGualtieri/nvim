-- ╔══════════════════════════════════════════════════════════╗
-- ║  init.lua — entry point for Neovim 0.12 configuration  ║
-- ╚══════════════════════════════════════════════════════════╝

-- Leader keys (must be set before lazy.nvim)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({
		'git', 'clone', '--filter=blob:none', '--branch=stable',
		lazyrepo, lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Core configuration
require('options')
require('keymaps')
require('autocmds')

-- Plugin manager
require('lazy').setup({
	spec = {
		{ import = 'plugins' },
		{ import = 'plugins.lang' },
	},
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				'matchit',
				'matchparen',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
})

if vim.g.neovide then  -- only apply these settings when inside Neovide

	-- vim.opt.guifont = "JetBrains Mono:h14"  -- font and size
	vim.g.neovide_cursor_animation_length = 0.025
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0

	vim.keymap.set("n", "<C-=>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.01
	end)
	vim.keymap.set("n", "<C-->", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.01
	end)
end
