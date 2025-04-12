-- lua/config/keymaps.lua
local map = vim.keymap.set
-- Save and quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
-- Terminal keymaps
map("n", "<leader>t", ":term<CR>", { desc = "Open terminal" })
map("n", "<leader>ty", ":term yazi<CR>", { desc = "Open yazi in terminal" })

