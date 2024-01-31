-- Git signs in gutter
return {
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
      require("gitsigns").setup()
      -- vim.keymap.set("n", ":Gitsigns")
    end
  },
}
