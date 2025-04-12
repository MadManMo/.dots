-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = {
      -- List all your LSP servers
      servers = {
        pyright = {},         -- Python
        ts_ls = {},           -- JavaScript/TypeScript
        clangd = {},          -- C/C++
        html = {},            -- HTML
        jdtls = {},           -- Java
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }, -- Recognize Vim globals
              },
            },
          },
        },                    -- Lua
        nil_ls = {},          -- Nix
        jsonls = {},          -- JSON
        gopls = {},           -- Go
        rust_analyzer = {},   -- Rust
        cssls = {},           -- CSS/SCSS/LESS
        solargraph = {},      -- Ruby
        intelephense = {},    -- PHP
        bashls = {},          -- Bash
        marksman = {},        -- Markdown
      },
      -- Define on_attach for LSP keymaps
      setup = {
        ["*"] = function(server, opts)
          local lspconfig = require("lspconfig")
          lspconfig[server].setup({
            on_attach = function(client, bufnr)
              local map_opts = { buffer = bufnr, remap = false }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)      -- Go to definition
              vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)            -- Show hover info
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)  -- Rename symbol
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts) -- Code actions
            end,
            capabilities = vim.lsp.protocol.make_client_capabilities(),
            settings = opts.settings or {},
          })
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "pyright",
        "typescript-language-server",
        "clangd",
        "vscode-langservers-extracted",
        "jdt-language-server",
        "lua-language-server",
        "nil",
        "gopls",
        "rust-analyzer",
        "solargraph",
        "intelephense",
        "bash-language-server",
        "marksman",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "ts_ls",
        "clangd",
        "html",
        "jdtls",
        "lua_ls",
        "nil_ls",
        "jsonls",
        "gopls",
        "rust_analyzer",
        "cssls",
        "solargraph",
        "intelephense",
        "bashls",
        "marksman",
      },
    },
  },
}
