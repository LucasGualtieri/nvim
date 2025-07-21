return {

	"mg979/vim-visual-multi",
	cond = not vim.g.vscode,

	init = function()

		-- Desativa os mapeamentos padrão do plugin
		vim.g.VM_default_mappings = 0

		vim.g.VM_add_cursor_at_pos_no_mappings = 1
		vim.g.VM_set_statusline = 0

		-- Define mapeamentos personalizados
		vim.g.VM_maps = {
			["Find Under"]         = "<C-n>",
			["Select All"]         = "<leader>ma",
			["Start Regex Search"] = "<leader>mr",
			["Add Cursor At Pos"]  = "<leader>mp",
			["Add Cursor Down"]    = "<M-j>",
			["Add Cursor Up"]      = "<M-k>",
			["Toggle Multiline"]   = "<leader>mt",
			["Toggle Mappings"]    = "<leader>mo",
		}

		local function visual_cursors_with_delay()
			-- Execute the vm-visual-cursors command.
			vim.cmd('silent! execute "normal! \\<Plug>(VM-Visual-Cursors)"')
			-- NOTE: N sei pra q o delay
			-- Introduce delay via VimScript's 'sleep' (set to 500 milliseconds here).
			-- vim.cmd('sleep 200m')
			-- Press 'A' in normal mode after the delay.
			vim.cmd('silent! execute "normal! A"')
		end

		vim.keymap.set("v", "<leader>mv", visual_cursors_with_delay, { desc = "Start VM Visual Cursors with delay" })
	end,
}
