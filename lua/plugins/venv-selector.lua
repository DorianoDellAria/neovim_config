return {
  "linux-cultist/venv-selector.nvim",
  ft = "python",
  dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap-python" },
  config = function()
    require("venv-selector").setup({
      options = { picker = "snacks" },
    })

    vim.keymap.set("n", "<leader>vs", ":VenvSelect<cr>", { desc = "Select venv"})
  end,
}
