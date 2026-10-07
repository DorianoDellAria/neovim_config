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

      -- On a reference: go to definition. On a definition: show references.
      nmap("gd", function()
        local win = vim.api.nvim_get_current_win()
        local cursor = vim.api.nvim_win_get_cursor(win)
        local line, col = cursor[1] - 1, cursor[2]
        local cur_uri = vim.uri_from_bufnr(bufnr)
        local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/definition" })
        local client = clients[1]
        if not client then
          return Snacks.picker.lsp_definitions()
        end
        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

        vim.lsp.buf_request_all(bufnr, "textDocument/definition", params, function(results)
          local on_definition = false
          for _, res in pairs(results) do
            local locs = res.result
            if locs then
              if locs.uri or locs.targetUri then
                locs = { locs }
              end
              for _, loc in ipairs(locs) do
                local uri = loc.targetUri or loc.uri
                local range = loc.targetSelectionRange or loc.range
                if
                  uri == cur_uri
                  and range
                  and range.start.line <= line
                  and range["end"].line >= line
                  and (range.start.line < line or range.start.character <= col)
                  and (range["end"].line > line or range["end"].character >= col)
                then
                  on_definition = true
                end
              end
            end
          end
          if on_definition then
            Snacks.picker.lsp_references()
          else
            Snacks.picker.lsp_definitions()
          end
        end)
      end, "[G]oto [D]efinition (or references if on definition)")
      nmap("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")
      nmap("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
      nmap("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
      nmap("<leader>ss", function() Snacks.picker.lsp_symbols() end, "[S]earch document [S]ymbols")
      nmap("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "[S]earch workspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", function()
        local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diags > 0 then
          vim.diagnostic.open_float()
        else
          vim.lsp.buf.hover()
        end
      end, "Diagnostic or Hover Documentation")
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
      nmap("<C-S-i>", vim.lsp.buf.format, "Format current buffer")
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
