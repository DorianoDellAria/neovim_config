return {
  "bloznelis/before.nvim",
  config = function()
    local before = require("before")
    before.setup()

    vim.keymap.set("n", "[e", before.jump_to_last_edit, { desc = "Jump to last edit" })
    vim.keymap.set("n", "]e", before.jump_to_next_edit, { desc = "Jump to next edit" })
    vim.keymap.set("n", "<leader>oe", before.show_edits_in_telescope, { desc = "[O]pen [E]dits list" })
  end,
}
