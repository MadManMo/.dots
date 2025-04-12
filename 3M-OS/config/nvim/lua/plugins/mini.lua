-- lua/plugins/mini.lua
return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup() -- Use default mini.ai setup
    end,
  },
}
