-- Plugin that show pending keybinds
return {
  "folke/which-key.nvim",
  config = function()
    -- document existing key chains
    require("which-key").register({
      ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "[O]pen", _ = "which_key_ignore" },
      ["<leader>v"] = { name = "[V]env", _ = "which_key_ignore" },
    })
  end,
}
