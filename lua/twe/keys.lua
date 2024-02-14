--[[
--	keys.lua
--	@twe.2024.02
--]]
--

-- Leader specifically set in init
-- vim.g.mapleader = " "	

-- Return to filebrowser
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- vim.keymap.set("n", "<Backspace>", "<cmd>execute \":normal 1\\<C-O>\"<CR>")
-- vim.keymap.set("n", "\\", "<cmd>execute \":normal 1\\<C-I>\"<CR>")

local bufjump_opts = { silent=true, noremap=true }
vim.keymap.set("n", "<Backspace>", "<cmd>lua require('bufjump').backward()<cr>", bufjump_opts)
vim.keymap.set("n", "\\", "<cmd>lua require('bufjump').forward()<cr>", bufjump_opts)

-- vim.keymap.set("n", "<Backspace>", "g;")
-- vim.keymap.set("n", "\\", "g,")

-- moves visual blocks around 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Harpoon Mappings
-- local mark = require("harpoon.mark")
-- local ui = require("harpoon.ui")
-- vim.keymap.set("n", "<leader>a", mark.add_file)
-- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- lelescope Mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

-- Formatting
vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end)

-- Buffer management
vim.keymap.set('n', '<Tab>', ":bNext<CR>")


-- LSP
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- -- Possession
-- local possession = require("nvim-possession")
-- vim.keymap.set("n", "<leader>sl", function() possession.list() end)
-- vim.keymap.set("n", "<leader>sn", function() possession.new() end)
-- vim.keymap.set("n", "<leader>su", function() possession.update() end)
-- vim.keymap.set("n", "<leader>sd", function() possession.delete() end)
