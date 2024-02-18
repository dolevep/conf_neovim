-- wut autocmd/
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

autocmd('QuitPre', {
  desc = "stop trouble causing trouble on quit",
  callback = function()
    require("trouble").close()
  end,
})
