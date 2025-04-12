return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo  = [[
    =================     ===============     ===============   ========  ========
    \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
    ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
    || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
    ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
    || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_ |\ . . . . ||
    ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
    || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
    ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
    ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
    ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
    ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
    ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
    ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_ / |  \/  |   ||
    ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
    ||.=='    _-'                                                     `' |  /==.||
    =='    _-'                        N E O V I M                         \/   `==
    \   _-'                                                                `-_   /
     `''                                                                      ``' 
      ]]
		dashboard.section.header.val = vim.split(logo, "\n")
                dashboard.section.buttons.val = {
                        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                        dashboard.button("g", " ".. " Find text", ":Telescope live_grep <CR>"),
                        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                        dashboard.button("s", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
                }
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
    end

      require("alpha").setup(dashboard.opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local plugin_count = stats.loaded
          local nvim_version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          -- Assign the footer value and redraw
          dashboard.section.footer.val = " ᴳᵒ ᵃʷᵃʸ  " .. nvim_version .. " 󱐋 " .. plugin_count .. "  𝘗𝘭𝘶𝘨𝘪𝘯𝘴 𝘓𝘰𝘢𝘥𝘦𝘥"
          pcall(vim.cmd.AlphaRedraw)
          end,
    })
    end,
  }
}
