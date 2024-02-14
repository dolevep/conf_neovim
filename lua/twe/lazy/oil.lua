return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer=true,
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        skip_confirm_for_simple_edits = true,
      })
    end
  }
}
