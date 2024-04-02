return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  config = function()
    local git_root = require("doriconfig.utils").find_git_root()
    require("venv-selector").setup({
      name = ".venv",
      path = git_root,
      parents = 0,
    })

    vim.keymap.set("n", "<leader>vs", ":VenvSelect<cr>", { desc = "Select venv"})
    vim.keymap.set("n", "<leader>vc", ":VenvSelectCached<cr>", { desc = "Activate cached venv"})
  end,
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
}
