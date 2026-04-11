# Neovim 0.12 Modern Configuration

This configuration is built from scratch strictly for **Neovim 0.12 (Nightly)** on macOS. It aims to provide a fast, modern IDE-like experience (with syntax highlighting meticulously tuned to match VSCode Dark+) while explicitly omitting outdated or deprecated APIs.

## 📂 Directory Structure

The configuration follows a modular approach, separating core Neovim settings from plugin specifications.

```text
~/.config/nvim/
├── init.lua                # Main entry point (bootstraps lazy.nvim)
├── lua/
│   ├── options.lua         # Core Vim options (indentation, UI, etc.)
│   ├── keymaps.lua         # Global, non-plugin keybindings
│   ├── autocmds.lua        # Editor event hooks (trim whitespace, yank highlight)
│   └── plugins/            # Plugin-specific configurations
│       ├── lsp.lua         # Core LSP, Mason, formatting & linters
│       ├── ui.lua          # VSCode theme overrides, statusline, minimap
│       ├── explorer.lua    # Oil.nvim and Neo-tree configurations
│       ├── ...             # Other modular plugins
│       └── lang/           # Language-specific LSP & Tooling setups
│           ├── java.lua    # Custom Java/Spring Boot tooling
│           ├── cpp.lua     # C/C++ clangd config
│           ├── python.lua  # Python pyright config
│           └── typescript.lua
└── README.md               # This documentation
```

## 🧠 Core Philosophy & Features

### 1. The Native Neovim 0.12 LSP API
Unlike older configs that rely heavily on `lspconfig.setup()`, this configuration embraces Neovim 0.12's native LSP management functions: `vim.lsp.config()` and `vim.lsp.enable()`. 

**How to add a new LSP:**
You do NOT need to configure the server inside `mason-lspconfig`. Instead:
1. Add the tool to the `ensure_installed` list in `lua/plugins/lsp.lua`.
2. Enable it globally by adding `vim.lsp.enable('SERVER_NAME')` inside `lsp.lua`.
3. *(Optional)* If the server requires specific initialization options or filetype commands, create a file in `lua/plugins/lang/` (e.g., `lang/go.lua`).

### 2. Complex Java Setup (`lua/plugins/lang/java.lua`)
The Java workflow is heavily optimized for Spring Boot, bypassing abstraction layers like `nvim-java` in favor of direct, granular control over `nvim-jdtls`.

- **JDTLS & Workspaces:** Each project receives an isolated index cache in `~/.local/share/nvim/jdtls-workspaces/`.
- **Bundles:** The configuration manually injects essential debugging and testing bundles (`java-debug-adapter`, `java-test`).
- **Spring Boot:** Integrated with `spring-boot.nvim`. The Spring Boot Language Server is automatically loaded if the project holds a `application.yml` or Spring Context.
- **Lombok:** Passed directly as a JVM agent (`-javaagent:lombok.jar`).

*To tweak Java behavior:* All Java auto-commands, LSP initializations, and keymaps are strictly isolated in `lang/java.lua`.

### 3. VSCode Dark+ Aesthetics (`lua/plugins/ui.lua`)
A significant effort is put into replicating the precise visual aesthetics of VSCode Dark+ inside the terminal.

We use the `vscode.nvim` plugin as a base, but Java and other complex languages are overridden via a specific `FileType` autocommand in `ui.lua`.
- **Why?** LSP Semantic Tokens (`@lsp.type...`) inherently override standard Treesitter syntax (`@keyword...`). 
- **Modifying Colors:** If you need to change how a color looks (e.g. changing `void` to Teal or `new` to Pink), you must update the specific `hl()` overrides inside the `FileType` callback in `lua/plugins/ui.lua`. The custom mapping gracefully links complex semantic tokens to precise Hex colors.

### 4. Zero-Friction Navigation & UI
- **Telescope:** Fuzzy finding (`<leader>pf`) uses `filename_first` so deeply nested files don't truncate exactly what you're looking for.
- **Oil:** Standard generic file exploration (`-` to open parent directory). Edits are made seamlessly like a standard buffer.
- **Diagnostics:** Inline diagnostics are replaced with `tiny-inline-diagnostic` for clean, multi-line error rendering. Deprecated APIs like `vim.diagnostic.goto_next()` have been successfully replaced by the unified `vim.diagnostic.jump()`.

## 🛠️ Typical Maintenance Workflows

**Updating Plugins:**
```vim
:Lazy sync
```
**Installing New Formatter/Linter/LSP:**
1. Open `lua/plugins/lsp.lua`.
2. Add the package name to `mason-tool-installer` list.
3. Run `:MasonToolsInstall` or restart Neovim.

**Modifying Editor Settings:**
Edit `lua/options.lua`. These are raw `vim.o` settings.

**Adding global keymaps:**
Edit `lua/keymaps.lua`. Use the modern `vim.keymap.set()` API syntax. Keep plugin-specific keymaps isolated within that plugin's `keys = {}` lazy block or `LspAttach` autocommand.
