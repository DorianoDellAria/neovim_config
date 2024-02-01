-- Git signs in gutter
return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { desc = "[G]it [P]review hunk" })
      vim.keymap.set(
        "n",
        "<leader>gt",
        ":Gitsigns toggle_current_line_blame<cr>",
        { desc = "[G]it [T]oggle current line blame" }
      )
    end,
  },
  {
    "tpope/vim-fugitive",
  },
}
