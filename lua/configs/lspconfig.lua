-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls", "clangd", "jdtls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
	}
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Can be '●', '▎', 'x'
    -- spacing = 4,
    -- wrap = true,
  },
  -- float = {
  --   border = "rounded",
  --   source = "always",
  -- },
  -- signs = true, -- Show signs in the sign column
  -- underline = {
  --   severity = vim.diagnostic.severity.ERROR,
  -- },
  -- update_in_insert = false,
})

-- Define highlight groups for diagnostics underlines
-- vim.cmd [[
--   highlight DiagnosticUnderlineError guifg=#E06C75 gui=underline
--   highlight DiagnosticUnderlineWarn guifg=#E5C07B gui=underline
--   highlight DiagnosticUnderlineInfo guifg=#61AFEF gui=underline
--   highlight DiagnosticUnderlineHint guifg=#98C379 gui=underline
-- ]]

-- typescript
lspconfig.tsserver.setup {
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
}
