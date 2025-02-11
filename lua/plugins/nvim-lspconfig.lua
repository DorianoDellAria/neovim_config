local function check_npm()
  return vim.fn.executable("npm") == 1
end
-- LSP
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim",           cond = check_npm },
    { "williamboman/mason-lspconfig.nvim", cond = check_npm },
    { "j-hui/fidget.nvim",                 tag = "legacy",  opts = {} },
    "folke/neodev.nvim",
  },
  config = function()
    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    local mason_status, mason = pcall(require, "mason")
    if mason_status then
      mason.setup()
    end
    local mason_lsp_status, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mason_lsp_status then
      mason_lspconfig.setup()
    end

    -- Setup neovim lua configuration
    require("neodev").setup()

    local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<A-CR>", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
      nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
      nmap("<C-A-l>", vim.lsp.buf.format, "Format current buffer")
      nmap("<leader>l", vim.diagnostic.open_float, "Show diagnostic")
    end

    local servers = {
      -- actionlint = {},
      astro = {},
      cssls = {},
      docker_compose_language_service = {},
      dockerls = {},
      gopls = {},
      jsonls = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
      -- mdx_analyser = {},
      pyright = {
        -- pyright = {
        --   disableOrganizeImports = true
        -- },
        -- python = {
        --   analysis = {
        --     ignore = { "*" }
        --   }
        -- }
      },
      ruff = {
        -- trace = "messages",
        -- init_options = {
        --   settings = {
        --     logLevel = "debug"
        --   }
        -- }
      },
      rust_analyzer = {
        cargo = {
          allFeatures = true,
        },
      },
      -- stylua = {},
      tailwindcss = {},
      ts_ls = {},
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Ensure the servers above are installed

    if mason_lsp_status then
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          })
        end,
      })
    end

    vim.diagnostic.config({
      virtual_text = false,
      float = {
        source = true,
        prefix = "● "
      },
      severity_sort = true,
    })
  end,
}
