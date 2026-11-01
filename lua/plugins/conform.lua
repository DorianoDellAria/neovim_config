return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<C-S-i>",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
      },
      -- Filetypes without a formatter above fall back to the attached LSP.
      default_format_opts = { lsp_format = "fallback" },
      formatters = {
        -- Only run biome in projects that have a biome config (uses node_modules/.bin/biome).
        biome = { require_cwd = true },
      },
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
      end
      conform.format({ async = true, range = range })
    end, { range = true, desc = "Format current buffer" })
  end,
}
