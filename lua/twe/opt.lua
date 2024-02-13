-- TODO: Vimspector ? 
-- TODO: Terminal integration of some kind?
-- TODO: Change between open buffers/windows intelligently.
-- TODO: Look to limit/purposefully use italics


-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end
--[[ 󰋼   󰴓
--     󱨛 󰈸 󰶯 󰍎 󰙎
--
--]]

--sign({name = 'DiagnosticSignError', text = ''})
sign({ name = 'DiagnosticSignError', text = '󰈸' })
sign({ name = 'DiagnosticSignWarn', text = '󰶯' })
sign({ name = 'DiagnosticSignHint', text = '󰍎' })
sign({ name = 'DiagnosticSignInfo', text = '󰙎' })

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])



--[[ LSP / Mason / Config / Formatting! ]]
-- was going to use lsp-format for formatting but it appears to be built in with any LSP? set command in keys.lua
require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers({
    function(server_name)
        -- THIS WILL SET VIM TO BE GLOBAL FOR LUA
        if server_name == "lua_ls" then
            require("lspconfig")[server_name].setup(
                { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
            )
        else
            require("lspconfig")[server_name].setup({})
        end
    end
})


--[[ INDENTING TABS AND OTHER FUCKERY ]]
-- Issues with tab reverting to 8 - super fucking annoying
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_set_option('autoindent', true)
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
vim.cmd("set number relativenumber")

vim.cmd("set shiftwidth =4") -- IMPORTANT: MUST be set =4, NO SPACE ALLOWED AFTER EQUALS
vim.cmd("set tabstop =4")
vim.cmd("set softtabstop =4")





--[[ COMPLETION ]]
local cmp = require("cmp")
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-l>'] = cmp.mapping.scroll_docs(5),
        ['<C-h>'] = cmp.mapping.scroll_docs(-5),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    }),
    -- Installed sources -- keyword length is how many letters before detection starts
    sources = cmp.config.sources({
        { name = 'path' },                                       -- file paths
        { name = 'nvim_lsp',               keyword_length = 1 }, -- from language server
        { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
        { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer',                 keyword_length = 5 }, -- source current buffer
        { name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
        { name = 'calc' },                                       -- source for math calculation
    }),
    {
        { name = 'buffer' },
    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                -- nvim_lsp = 'λ',
                -- vsnip = '⋗',
                -- buffer = 'Ω',
                -- path = '🖫',
                nvim_lsp = '󱉟',
                vsnip = '⋗',
                buffer = '...',
                path = '\\',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})


--[[ TREESITTER ]]
require 'nvim-treesitter.configs'.setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "cpp", "toml" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
    indent = { enable = true },


    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})
--]]

--[[ FOLDING ]]
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd("set nofoldenable")
