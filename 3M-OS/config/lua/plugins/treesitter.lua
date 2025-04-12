return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "python",
        "javascript",
        "typescript",
        "c",
        "cpp",
        "html",
        "java",
        "nix",
        "json",
        "go",
        "rust",
        "css",
        "ruby",
        "php",
        "bash",
        "markdown",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = false,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
