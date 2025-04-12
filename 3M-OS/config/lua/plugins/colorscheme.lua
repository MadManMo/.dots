return {
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#727169" })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#FFA500" })
      vim.api.nvim_set_hl(0, "DashboardShortCut", { fg = "#727169" })
    end,
  },
}
