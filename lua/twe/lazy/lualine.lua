-- TODO: This is going to need a massive rewrite at some stage, it's been tweaked to death

-- Extenstions
-- Winbar took some tweaking - needs to have a blank in the main config or it never works
local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}

local _trouble = function()
  -- write actual checks you dolt
  local ok, trouble = pcall(require, 'trouble')
  --     
  local title = "  trouble"
  local _lualine_trouble = {
    sections = {
      lualine_a = {
        {
          "",
          padding = { left = 1, right = 2 },
          color = { bg = colors.yellow, fg = "#000000" },
          separator = { left = '█', right = '' },
          fmt = function()
            return title
          end
        }
      },
      lualine_b = { "" },
      lualine_c = { "" },
      lualine_x = { "" },
      lualine_y = { "" },
      lualine_z = { "" },
    },
    winbar = {
      lualine_a = {
      }
    },
    filetypes = { "Trouble", },
  }
  return _lualine_trouble
end

local _oil = function()
  local _lualine_oil = {
    sections  = {},
    winbar    = {
      lualine_a = {
        {
          "",
          padding = { left = 0, right = 0 },
          separator = { left = '  ', right = ' ' },
          fmt = function()
            local ret_pre = ""
            local ret_aff = ""
            local ok, oil = pcall(require, 'oil')
            if ok then
              return ret_pre .. vim.fn.fnamemodify(oil.get_current_dir(), ':~') .. ret_aff
            else
              return ret_pre .. ''
            end
          end
        }
      },
      lualine_b = {
        {
          "",
          color = { bg = "", fg = "" },
          fmt = function()
            return ""
          end
        }
      }
    },
    filetypes = { "oil" },
  }
  return _lualine_oil
end

-- LSP clients attached to buffer
local clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return table.concat(c, '|')
  -- return '󰍕 ' .. table.concat(c, '|')
  -- return '\u{f085} ' .. table.concat(c, '|')
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "f-person/git-blame.nvim",
  },
  config = function()
    -- Import and configure git-blame
    -- local git_blame = require('gitblame')
    -- vim.g.gitblame_display_virtual_text = 0 -- disables showing the blame text inline ... might actually want....
    -- decided against git-blame for now

    -- customise some colours
    local theme_twe = require('lualine.themes.ayu_dark')

    theme_twe.normal.b.bg = ""
    theme_twe.normal.c.bg = ""

    theme_twe.inactive.a.bg = ""
    theme_twe.inactive.b.bg = ""
    theme_twe.inactive.c.bg = ""

    require("lualine").setup({
      -- BUG IMPORTANT: For whatever reason colours/separators/etc being set here are having a
      -- unpredictable effect on incline's icon's colour - often it's 'gray' when it should be
      -- blue/orange/etc

      options = {
        icons_enabled = true,
        theme = theme_twe,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        component_separators = '|',
        --
        section_separators = { left = '', right = '' },
        -- disabled_filetypes = {
        --   statusline = {},
        --   winbar = {},
        -- },
        -- ignore_focus = {},
        always_divide_middle = false,
        globalstatus = false,
        refresh = {
          statusline = 50,
          tabline = 1000,
          winbar = 1000
        },
      },
      sections = {
        lualine_a = {
          {
            padding = { left = 1, right = 2 },
            -- 
            -- 󰍕
            -- 󰸞
            -- 
            -- 
            "diagnostics",
            fmt = function(str)
              local clients = clients_lsp()
              local mode = vim.api.nvim_get_mode()["mode"]
              if clients == '' and mode ~= 't' then
                -- 󱃞   󰍕 
                return "󰱶 "
              elseif str == '' and mode ~= 't' then
                -- return "󰍕" 󰍕
                return " " .. vim.bo.filetype
              else
                return str
              end
            end,
            sources = { "nvim_lsp" },
            sections = {
              'error',
              'warn',
              'hint',
              'info',
            },
            color = function()
              local clients = clients_lsp()
              local _col = {}
              if clients == "" then
                _col = { bg = colors.darkgray, fg = colors.white }
              else
                _col = { bg = theme_twe.insert.a.bg, fg = "#000000" }
              end
              return _col
            end,
            diagnostics_color =
            {
              error = { bg = colors.red, fg = "#000000" },
              warn = { bg = colors.yellow, fg = "#000000" },
              hint = { bg = colors.white, fg = "#000000" },
              info = { bg = colors.lightgray, fg = "#000000" },
            },
            symbols = { error = '󰈸' },
            -- separator = { left = '', right = '' },
            separator = { left = '█', right = '' },
            draw_empty = false,
            update_in_insert = true,
          }
        },
        lualine_b = {
          {
            "mode",
            padding = 0,
            color = { fg = colors.lightgray, bg = "" },
            fmt = function()
              local mode = vim.api.nvim_get_mode()["mode"]
              if mode ~= 'n' then
                return ""
              end
            end,
            draw_empty = true,
          }
        },
        lualine_c = {
          {
            'mode',
            separator = { left = '', right = '' },
            padding = { left = 1 },
            color = function()
              local _bg = ""
              local mode = vim.api.nvim_get_mode()["mode"]
              if mode == 'v' or mode == "V" then
                _bg = theme_twe.visual.a.bg
              elseif mode == 'R' or mode == 'r' or mode == 'no' then
                _bg = theme_twe.replace.a.bg
              elseif mode == 'i' or mode == 'c' then
                _bg = theme_twe.insert.a.bg
              else
                return { fg = "#000000", bg = "#ffffff" }
              end
              return { fg = "#000000", bg = _bg }
            end,
            fmt = function()
              local mode = vim.api.nvim_get_mode()["mode"]
              if mode == 'n' then
                return ""
              elseif mode == 'v' or mode == 'V' then
                return "  "
              elseif mode == 'r' or mode == 'R' or mode == 'no' then
                return "󰬢 "
              elseif mode == 'i' then
                return "  "
              elseif mode == 'c' then
                return "󰜎 "
              elseif mode == 't' then
                return "󰞷 "
              else
                return mode
              end
            end

          },
        },
        lualine_x = {
          {
            "diff",
          }
        },
        lualine_y = {
          {
            "branch",
            color = { bg = colors.white, fg = "#000000" },
            separator = { left = "", right = " " }
          }
        },
        lualine_z = {
          {
            "location",
            padding = {
              left = 0,
              right = 1,
            },
            color = { bg = "", fg = colors.gray },
            separator = { left = ' ', right = '' },
            fmt = function(str)
              local mode = vim.api.nvim_get_mode()["mode"]
              if mode == "t" then
                return ""
              else
                return str
              end
            end
          }
        },
      },

      inactive_sections = {
        lualine_a = {
          {
            padding = { left = 1, right = 2 },
            -- 
            -- 󰍕
            -- 󰸞
            -- 
            -- 
            "diagnostics",
            fmt = function(str)
              local clients = clients_lsp()
              local mode = vim.api.nvim_get_mode()["mode"]
              if clients == '' and mode ~= 't' then
                return "󱃞"
              elseif str == '' and mode ~= 't' then
                -- return "󰍕" 󰍕
                return " " .. vim.bo.filetype
              else
                return str
              end
            end,
            sources = { "nvim_lsp" },
            sections = {
              'error',
              'warn',
              'hint',
              'info',
            },
            color = function()
              local clients = clients_lsp()
              local _col = {}
              if clients == "" then
                _col = { bg = colors.darkgray, fg = colors.white }
              else
                _col = { bg = theme_twe.insert.a.bg, fg = "#000000" }
              end
              return _col
            end,
            diagnostics_color =
            {
              error = { bg = colors.red, fg = "#000000" },
              warn = { bg = colors.yellow, fg = "#000000" },
              hint = { bg = colors.white, fg = "#000000" },
              info = { bg = colors.lightgray, fg = "#000000" },
            },
            symbols = { error = '󰈸' },
            -- separator = { left = '', right = '' },
            separator = { left = '█', right = '' },
            draw_empty = false,
            update_in_insert = true,
          }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          {
            "branch",
            color = { bg = colors.white, fg = "#000000" },
            separator = { left = "", right = " " }
          }
        },
        lualine_z = {
          {
            "location",
            padding = {
              left = 0,
              right = 1,
            },
            color = { bg = "", fg = colors.gray },
            separator = { left = ' ', right = '' },
          }
        },
      },

      -- tabline is largely not used anyway.
      tabline = {},
      inactive_tabline = {},

      winbar = {
        lualine_a = {
          {
            function()
              return ""
            end
          }

        }
      },
      inactive_winbar = {},

      extensions = {
        _trouble(),
        _oil()
      }
    })
  end

}
