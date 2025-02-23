-- Plugin that show pending keybinds
return {
  "folke/which-key.nvim",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    -- document existing key chains
    require("which-key").add({
      {"<leader>d", group = "[D]ocument"},
      {"<leader>g", group = "[G]it"},
      {"<leader>r", group = "[R]ename"},
      {"<leader>s", group = "[S]earch"},
      {"<leader>w", group = "[W]orkspace"},
      {"<leader>o", group = "[O]pen"},
      {"<leader>v", group = "[V]env"},
      {"<leader>b", group = "[B]uffer"},
      {"<leader>u", group = " Notification"},
    })
  end,
}
