-- ╔══════════════════════════════════════════════════════════╗
-- ║  options.lua — editor settings for Neovim 0.12          ║
-- ╚══════════════════════════════════════════════════════════╝

local o = vim.o -- Shorthand for vim.o (global option access)

-- ── Core behaviour ──────────────────────────────────────────
o.number = true         -- Show absolute line number on the current line
o.relativenumber = true -- Show relative line numbers on all other lines (great for jump counts like 5j)
o.signcolumn = 'yes:2'  -- Always show 2-column sign gutter (prevents layout shift; fits git + diagnostic signs)
o.cursorline = true     -- Highlight the line the cursor is on (visual anchor)
o.scrolloff = 8         -- Keep 8 lines visible above/below the cursor when scrolling vertically
o.sidescrolloff = 8     -- Keep 8 columns visible left/right of the cursor when scrolling horizontally
o.wrap = false          -- Don't visually wrap long lines — scroll horizontally instead
o.splitright = true     -- New vertical splits open to the right of the current window
o.splitbelow = true     -- New horizontal splits open below the current window
o.winborder = 'rounded' -- Neovim 0.12: sets rounded borders globally for ALL floating windows (hover, completion, etc.)
o.laststatus = 3        -- Single global statusline shared by all windows (instead of one per window)
o.showmode = false      -- Hide "-- INSERT --" from the command line — lualine already shows the mode
-- o.colorcolumn = "80"
-- o.updatetime = 50

vim.opt.mouse = "a"          -- enable mouse everywhere
vim.opt.mousemodel = "popup" -- right-click popup menu in GUI / terminals that support it

-- ── Indentation ─────────────────────────────────────────────
o.tabstop = 4        -- A <Tab> character counts as 2 columns visually
o.shiftwidth = 4     -- Indentation commands (>>, <<, ==) shift by 2 columns
o.expandtab = true   -- Pressing <Tab> inserts spaces instead of a literal tab character
o.smartindent = true -- Auto-indent new lines based on syntax (e.g., after '{' or ':')
-- o.softtabstop = 4    -- TODO: Explain what this is.

-- ── Search ──────────────────────────────────────────────────
o.ignorecase = true -- Search is case-insensitive by default (e.g., /foo matches Foo, FOO)
o.smartcase = true  -- BUT if the search pattern contains uppercase, make it case-sensitive
o.hlsearch = true   -- Highlight all matches of the last search pattern
o.incsearch = true  -- Show matches incrementally as you type the search pattern

-- ── Files ───────────────────────────────────────────────────
o.exrc = true      -- Source project-local .nvim.lua when cwd is the project (run :trust once per repo)
o.undofile = true  -- Persist undo history to disk so you can undo even after closing and reopening a file
o.swapfile = false -- Don't create .swp recovery files (we rely on undofile + git instead)
o.backup = false   -- Don't create ~ backup files before overwriting
o.updatetime = 250 -- Write swap (if enabled) and trigger CursorHold after 250ms of idle — also speeds up gitsigns/diagnostics
o.timeoutlen = 300 -- Wait 300ms for a mapped key sequence to complete (e.g., pressing <leader> then the next key)
-- o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- ── Appearance ──────────────────────────────────────────────
o.termguicolors = true -- Enable 24-bit RGB color in the terminal (required for modern colorschemes)
o.conceallevel = 0     -- Show all text as-is — never hide/replace characters (e.g., show `` ` `` in markdown)
o.pumheight = 10       -- Limit the popup completion menu to 10 visible items (prevents it from covering the whole screen)

-- ── Clipboard ───────────────────────────────────────────────
o.clipboard = 'unnamedplus' -- Use the system clipboard for all yank/delete/paste (y, d, p use Ctrl+C/Ctrl+V clipboard)
