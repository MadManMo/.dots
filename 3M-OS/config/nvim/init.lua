-- init.lua

-- Leader key setup
-- Defines the global and local leader keys for keybindings (space in this case)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim (plugin manager)
-- Automatically installs lazy.nvim if not present by cloning it from GitHub
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup with lazy.nvim
-- Configures plugins to be lazily loaded; mini.nvim, LSP, and Kanagawa are included
require("lazy").setup({
  -- Mini.nvim: a collection of small, independent modules
  { "echasnovski/mini.nvim", branch = "main" },

  -- LSP support for language-specific features
  { "neovim/nvim-lspconfig" },

  -- Kanagawa colorscheme for a pleasant aesthetic
  { "rebelot/kanagawa.nvim" },

  -- Telescope: Fuzzy finder for files, buffers, and more
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}, {
  -- Performance tweaks: disables some built-in plugins
  performance = {
    rtp = {
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "tarPlugin", "tutor" },
    },
  },
})

-- General Neovim settings
-- Basic editor settings for usability and appearance
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers for easier navigation
vim.opt.mouse = "a"            -- Enable mouse support in all modes
vim.opt.ignorecase = true      -- Case-insensitive searching
vim.opt.smartcase = true       -- Case-sensitive search if uppercase is used
vim.opt.clipboard = "unnamedplus" -- Sync clipboard with system clipboard
vim.opt.termguicolors = true   -- Enable 24-bit RGB colors for themes

-- mini.nvim module setup
-- Configures various mini.nvim modules for enhanced functionality

-- mini.icons
require("mini.icons").setup()

-- Precompute icons for each item
local new_buffer_icon = "󰈔" -- Nerd Font: nf-md-file (new file)
local find_file_icon = "" -- Nerd Font: nf-fa-search (magnifying glass)
local session_load_icon = "" -- Nerd Font: nf-cod-history (history/session)
local session_save_icon = "󰳽" -- Nerd Font: nf-md-content_save (save)
local yazi_icon = "󰝰" -- Nerd Font: nf-md-folder_open (directory)

-- Define padding for menu items
local menu_padding = string.rep(" ", 32)

-- Define a custom highlight for the shortcut keys (you can customize this)
vim.api.nvim_set_hl(0, 'ShortcutKey', {
  fg = '#FF00FF',  -- Pink color, change to any color you want
  italic = false,     -- Makes the shortcut bold (optional)
})

-- mini.starter: A lightweight dashboard when opening Neovim startup
require("mini.starter").setup({
  -- Header: ASCII art or simple text displayed at the top
  header = [[
    =================     ===============     ===============   ========  ========
    \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
    ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
    || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
    ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
    || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
    ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
    || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
    ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
    ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
    ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
    ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
    ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
    ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
    ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
    ||.=='    _-'                                                     `' |  /==.||
    =='    _-'                        N E O V I M                         \/   `==
    \   _-'                                                                `-_   /
     `''                                                                      ``' 
  ]],

  -- Items: Sections of the dashboard
  items = {
    -- New Buffer
    {
      name = menu_padding .. new_buffer_icon .. "  New Buffer",
      action = "enew",
      section = "",
    },

    -- Find File (using Telescope find_files)
    {
      name = menu_padding .. find_file_icon .. "  Find File",
      action = "Telescope find_files",
      section = "",
    },

    -- Recently Opened Files (5 recent files)
    require("mini.starter").sections.recent_files(5, true, false),

    -- Load Session
    {
      name = menu_padding .. session_load_icon .. "  Open Last Session",
      action = "lua MiniSessions.select('read')",
      section = "",
    },

    -- Save Session
    {
      name = menu_padding .. session_save_icon .. "  Save Session",
      action = "lua MiniSessions.select('write')",
      section = "",
    },

    -- Open Yazi
    {
      name = menu_padding .. yazi_icon .. "  Open Yazi",
      action = "term yazi",
      section = "",
    },
  },

  -- Footer: Custom message
  footer = "Welcome! Today is " .. os.date("%Y-%m-%d"),

  -- Customize appearance
  content_hooks = {
    require("mini.starter").gen_hook.aligning("center", "center"),
    
    -- Custom hook to append shortcuts and align them in a column
    function(content)
      local query_keys = "EFHGSY"
      local item_idx = 0
      local max_item_length = 0  -- Variable to store the length of the widest item

      -- First pass: calculate the width of the longest item
      for _, line in ipairs(content) do
        for _, unit in ipairs(line) do
          if unit.item and unit.string:find(menu_padding) then
            local name_with_icon = unit.string:sub(#menu_padding + 1)
            local display_length = vim.fn.strdisplaywidth(name_with_icon)
            max_item_length = math.max(max_item_length, display_length)
          end
        end
      end

      -- Second pass: align the shortcuts dynamically
      item_idx = 0
      local shortcut_column = max_item_length + 5 -- Add some padding to the longest item

      for _, line in ipairs(content) do
        for _, unit in ipairs(line) do
          if unit.item and unit.string:find(menu_padding) then
            item_idx = item_idx + 1
            if item_idx <= #query_keys then
              local name_with_icon = unit.string:sub(#menu_padding + 1)
              local display_length = vim.fn.strdisplaywidth(name_with_icon)
              local padding = string.rep(" ", shortcut_column - display_length)
              local key = query_keys:sub(item_idx, item_idx)

              -- Apply the custom highlight for the shortcut (removes '[]')
              unit.string = unit.string .. padding .. key
                 vim.cmd("highlight ShortcutKey guifg=#FF00FF") -- Ensure highlight is applied
            end
          end
        end
      end

      return content
    end,
  },

-- Keybindings (mapping to the keys: e, f, h, g, s, y)
  query_updaters = "EFHGSY",
})

-- mini.statusline: A minimal statusline with useful info
require("mini.statusline").setup()

-- mini.comment: Easy commenting/uncommenting with gc/gcc
require("mini.comment").setup()

-- mini.pairs: Automatically pairs brackets, quotes, etc.
require("mini.pairs").setup()

-- mini.surround: Adds commands to surround text with characters (e.g., quotes, parens)
require("mini.surround").setup()

-- mini.files: A file explorer alternative to netrw
require("mini.files").setup()
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "Open file explorer" })

-- mini.basics: Provides basic syntax highlighting and other essentials
require("mini.basics").setup()

-- mini.completion: LSP-driven autocompletion
require("mini.completion").setup()
vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true }) -- Next completion
vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true }) -- Previous completion

-- mini.bufremove: Delete buffers without closing windows
require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete buffer" })

-- mini.tabline: A minimal tabline for buffer management
require("mini.tabline").setup()
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" }) -- Next buffer
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { desc = "Previous buffer" }) -- Previous buffer

-- mini.notify: Notification system for Neovim events
require("mini.notify").setup()

-- mini.sessions: Save and restore Neovim sessions
require("mini.sessions").setup({
  autowrite = true, -- Automatically save sessions
})
vim.keymap.set("n", "<leader>ss", "<cmd>lua MiniSessions.select('write')<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sl", "<cmd>lua MiniSessions.select('read')<cr>", { desc = "Load session" })


-- Terminal keybindings using Neovim’s built-in terminal
vim.keymap.set("n", "<leader>t", ":term<CR>", { desc = "Open terminal" })
vim.keymap.set("n", "<leader>ty", ":term yazi<CR>", { desc = "Open yazi in terminal" })

-- LSP Configuration
-- Sets up language servers for code intelligence across multiple languages
local lspconfig = require("lspconfig")
local servers = {
  "pyright",           -- Python LSP for type checking and completion
  "ts_ls",          -- JS/TS LSP, also helps with JSON in some cases
  "clangd",            -- C/C++ LSP for code navigation and diagnostics
  "html",              -- HTML LSP for web development
  "jdtls",             -- Java LSP (mapped to java-language-server in Nix)
  "lua_ls",            -- Lua LSP, great for Neovim scripting
  "nil_ls",            -- Nix LSP for configuration files
  "jsonls",            -- JSON LSP for schema validation and completion
  "gopls",             -- Go LSP for backend and systems programming
  "rust_analyzer",     -- Rust LSP for systems programming
  "cssls",             -- CSS/SCSS/LESS LSP for styling
  "solargraph",        -- Ruby LSP for Rails and scripting
  "intelephense",      -- PHP LSP for web development
  "bashls",            -- Bash LSP for shell scripting
  "marksman",          -- Markdown LSP for documentation
}

-- on_attach: Defines keybindings triggered when an LSP attaches to a buffer
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)      -- Go to definition
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)            -- Show hover info
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- Rename symbol
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
end

-- Setup each LSP server with common settings
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    -- Language-specific settings (e.g., Lua globals for Neovim)
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" }, -- Recognize Vim globals to avoid warnings
        },
      },
    },
  }
end

-- Kanagawa colorscheme setup
-- Configures the Kanagawa theme with custom options
require("kanagawa").setup({
  transparent = false, -- Set to true for a transparent background
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none", -- Clean gutter background
        },
      },
    },
  },
})
vim.cmd("colorscheme kanagawa") -- Apply the Kanagawa theme

-- Additional keybindings
-- Custom keymaps for common actions
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" }) -- Save with <Space>w
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })      -- Quit with <Space>q
