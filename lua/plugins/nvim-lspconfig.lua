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
      nmap("g.", vim.lsp.buf.code_action, "[C]ode [A]ction")

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

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    vim.lsp.config("*", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Configure individual servers
    vim.lsp.config("astro", {})

    vim.lsp.config("cssls", {})

    vim.lsp.config("docker_compose_language_service", {})

    vim.lsp.config("dockerls", {})

    vim.lsp.config("gopls", {})

    vim.lsp.config("jsonls", {})

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config("pyright", {
      settings = {
        -- pyright = {
        --   disableOrganizeImports = true
        -- },
        -- python = {
        --   analysis = {
        --     ignore = { "*" }
        --   }
        -- }
      },
    })

    vim.lsp.config("ruff", {
      -- trace = "messages",
      -- init_options = {
      --   settings = {
      --     logLevel = "debug"
      --   }
      -- }
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        cargo = {
          allFeatures = true,
        },
      },
    })

    vim.lsp.config("tailwindcss", {})

    vim.lsp.config("ts_ls", {})


    -- Ensure the servers above are installed
    if mason_lsp_status then
      mason_lspconfig.setup({
        ensure_installed = {
          "astro",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "gopls",
          "jsonls",
          "lua_ls",
          "pyright",
          "ruff",
          "rust_analyzer",
          "tailwindcss",
          "ts_ls",
        },
        automatic_enable = true, -- New v2 setting (default: true)
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
