-- git-blame is actually really sick - but largely useless as a solo dev i think... maybe
return {
  "f-person/git-blame.nvim",
  config =  function()
    require("gitblame").setup({
      enabled = false,
    })
  end
}
