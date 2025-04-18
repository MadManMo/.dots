-- init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
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

-- Load LazyVim and plugins
require("lazy").setup({
  spec = {
    -- Import LazyVim's default plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Add mini.ai plugin
    { "echasnovski/mini.ai", version = false, opts = {} },
    -- Import custom plugins (LSPs, colorscheme, etc.)
    { import = "plugins" },
  },
  defaults = {
    lazy = true, -- Enable lazy-loading
    version = false, -- Use latest commits
  },
  performance = {
    rtp = {
      -- Disable unused built-in plugins (same as your config)
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "tarPlugin", "tutor" },
    },
  },
})
