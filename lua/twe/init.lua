vim.g.mapleader = " "
vim.cmd("set termguicolors")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("twe.lazy", {
    change_detection = { notify = false, },
})

require("twe.keys")
require("twe.opt")
require("twe.autocmds")

-- Colorscheme set here 
vim.cmd("colorscheme ayu")
vim.cmd("set laststatus=2")
vim.cmd("setlocal laststatus=2")
