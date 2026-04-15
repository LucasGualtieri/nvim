-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lang/latex.lua — VimTeX + TexLab (Skim)        ║
-- ╚══════════════════════════════════════════════════════════╝
--
-- Prerequisites (macOS):
--   • MacTeX (or BasicTeX) so `latexmk` is on PATH
--   • Skim.app — https://skim-app.sourceforge.net/
--
-- Skim inverse search (Sync → Preset → Custom):
--   Command: nvim
--   Arguments: --headless -c "VimtexInverseSearch %line '%file'"
--   (Use the full path to nvim if Skim cannot find it.)
--
-- After opening a .tex file: run :VimtexCompile (<localleader>ll) for
-- continuous latexmk; PDF opens in Skim. Diagnostics: TexLab + VimTeX log.

local LATEX_FT = { 'tex', 'plaintex', 'bib' }

return {
	-- ── VimTeX (compile, PDF, SyncTeX, motions) ───────────────
	{
		'lervag/vimtex',
		ft = { 'tex', 'plaintex' },
		init = function()
			vim.g.vimtex_view_method = 'skim'
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
			vim.g.vimtex_view_skim_reading_bar = 1
			-- Do not auto-open quickfix on errors; use LSP diagnostics + :VimtexLog
			vim.g.vimtex_quickfix_mode = 0
			-- Prefer Treesitter for highlighting; VimTeX still provides compile/fold/maps
			vim.g.vimtex_syntax_enabled = 0
			-- latexmk (continuous / :VimtexCompile) is the default compiler — no override needed
		end,
		config = function()
			local group = vim.api.nvim_create_augroup('nvim-config.vimtex-tex', { clear = true })
			vim.api.nvim_create_autocmd('FileType', {
				group = group,
				pattern = { 'tex', 'plaintex' },
				callback = function()
					vim.opt_local.conceallevel = 2
					vim.opt_local.concealcursor = 'nc'
				end,
			})
		end,
	},

	-- ── TexLab (LSP: refs, citations, diagnostics) ────────────
	-- No `ft` on this spec: nvim-lspconfig is already loaded from plugins/lsp.lua;
	-- `init` runs when that plugin loads so `vim.lsp.config` is registered before enable().
	{
		'neovim/nvim-lspconfig',
		dependencies = { 'mason-org/mason.nvim' },
		init = function()
			vim.lsp.config('texlab', {
				cmd = { 'texlab' },
				filetypes = LATEX_FT,
				root_markers = { '.git', 'main.tex', '.latexmkrc', 'latexmkrc' },
				settings = {
					texlab = {
						-- VimTeX + latexmk own the compile loop; avoid double-build on save
						build = {
							executable = 'latexmk',
							args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
							onSave = false,
							forwardSearchAfter = false,
						},
						forwardSearch = {
							executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
							args = { '-b', '%l', '%p', '%f' },
						},
						chktex = {
							onOpenAndSave = true,
						},
					},
				},
			})
		end,
	},
}
