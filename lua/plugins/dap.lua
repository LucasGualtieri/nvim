-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/dap.lua — debug adapter protocol               ║
-- ╚══════════════════════════════════════════════════════════╝

return {
	-- ── nvim-dap ──────────────────────────────────────────────
	{
		'mfussenegger/nvim-dap',
		keys = {
			{ '<leader>db', function() require('dap').toggle_breakpoint() end,                                    desc = 'DAP: Toggle breakpoint' },
			{ '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'DAP: Conditional breakpoint' },
			{ '<leader>dc', function() require('dap').continue() end,                                             desc = 'DAP: Continue / Start' },
			{ '<leader>dn', function() require('dap').step_over() end,                                            desc = 'DAP: Step over' },
			{ '<leader>di', function() require('dap').step_into() end,                                            desc = 'DAP: Step into' },
			{ '<leader>do', function() require('dap').step_out() end,                                             desc = 'DAP: Step out' },
			{ '<leader>dr', function() require('dap').repl.open() end,                                            desc = 'DAP: Open REPL' },
		},
		dependencies = {
			-- ── DAP UI ────────────────────────────────────────────
			{
				'rcarriga/nvim-dap-ui',
				dependencies = { 'nvim-neotest/nvim-nio' },
				keys = {
					{ '<leader>du', function() require('dapui').toggle() end, desc = 'DAP: Toggle UI' },
				},
				config = function()
					local dap = require('dap')
					local dapui = require('dapui')
					dapui.setup()

					-- Auto open/close DAP UI on session start/end
					dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
					dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
					dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
				end,
			},

			-- ── Virtual text ──────────────────────────────────────
			{
				'theHamsta/nvim-dap-virtual-text',
				opts = {},
			},

			-- ── Python debug adapter ──────────────────────────────
			{
				'mfussenegger/nvim-dap-python',
				ft = 'python',
				config = function()
					local mason_path = vim.fn.stdpath('data') .. '/mason/'
					require('dap-python').setup(mason_path .. 'packages/debugpy/venv/bin/python')
				end,
			},
		},
	},
}
