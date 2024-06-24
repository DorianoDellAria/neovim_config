return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  config = function()
    require("venv-selector").setup({})

    vim.keymap.set("n", "<leader>vs", ":VenvSelect<cr>", { desc = "Select venv"})
  end,
}
