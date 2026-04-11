-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lang/cpp.lua — clangd + clangd_extensions      ║
-- ╚══════════════════════════════════════════════════════════╝

return {
  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp', 'objc', 'objcpp' },
    dependencies = { 'neovim/nvim-lspconfig' },
    init = function()
      vim.lsp.config('clangd', {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        root_markers = { 'compile_commands.json', '.clangd', 'CMakeLists.txt', '.git' },
      })
    end,
    config = function()
      vim.lsp.enable('clangd')

      require('clangd_extensions').setup({
        inlay_hints = { inline = true },
      })

      vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<CR>', {
        desc = 'C/C++: Switch header/source',
      })
    end,
  },
}
