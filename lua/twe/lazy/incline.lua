return {
  "b0o/incline.nvim",
  opts = {},
  -- event = "VeryLazy",
  config = function()
    local helpers = require 'incline.helpers'
    require('incline').setup({
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false, -- for now - can possibly get rid of the status bar completely?
      },
      window = {
        padding = 0,
        margin = { horizontal = 3, vertical = 2 },
        placement = {
          horizontal = "right",
          vertical = "bottom",
        },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        local buffer = {
          modified and " + " or ' ',
          { filename, gui = modified and 'bold,italic' or 'bold' },
          ' ',
          -- ft_icon and { ' ', ft_icon, ' ', guifg = ft_color, guibg = helpers.contrast_color(ft_color) } or '',
          ft_icon and { ' ', ft_icon, ' ', guifg = ft_color, guibg = "" } or '',
          ' ',
          --guibg = '#44406e',
        }
        return buffer
      end,
    })
  end


  -- First attempts
  --  require("incline").setup({
  --    window = {
  --      options = {
  --        signcolumn='auto',
  --        wrap = false,
  --      },
  --      padding = 0,
  --      padding_char = ".",
  --      placement = {
  --        horizontal = "right",
  --        vertical = "top"
  --      },
  --      width = "fit",
  --
  --    },
  -- hide = {
  -- 	only_win = true,
  -- },
  -- 	render = function(props)
  --   if props.focused then
  --     return require('incline.presets').basic(props)
  --     -- or return whatever you want to render in the focused window
  --   end
  --
  --   return nil
  -- end,
  --   });
  -- end

}
