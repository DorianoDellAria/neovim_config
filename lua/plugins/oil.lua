return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function ()
    require("oil").setup({
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["gr"] = "actions.refresh"
      },
    })
    vim.keymap.set("n", "-", ":Oil<cr>", { desc = "Open oil" } )
  end,
}
