return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.keymap.set('n', '=', 
    function() 
      vim.cmd("TroubleToggle")
      -- require('barbecue.ui').toggle(false)
    end)
    require("trouble").setup({
      padding = false,
      -- auto_open = true,
      auto_preview = true,
      auto_close = true,
    })
  end
}
