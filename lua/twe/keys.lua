--[[
--	keys.lua
--	@twe.2024.02
--]]

-- Leader specifically set in init
-- vim.g.mapleader = " "	

-- Return to filebrowser
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- moves visual blocks around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Harpoon Mappings
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)


-- Telescope Mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

-- Formatting
vim.keymap.set('n', '<leader>ff', function() vim.lsp.buf.format() end)


-- Possession
local possession = require("nvim-possession")
vim.keymap.set("n", "<leader>sl", function() possession.list() end)
vim.keymap.set("n", "<leader>sn", function() possession.new() end)
vim.keymap.set("n", "<leader>su", function() possession.update() end)
vim.keymap.set("n", "<leader>sd", function() possession.delete() end)
