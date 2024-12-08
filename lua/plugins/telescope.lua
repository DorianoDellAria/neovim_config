-- Fuzzy Finder
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
        live_grep_args = {
          auto_quoting = false, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = {    -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              -- ["<C-space>"] = actions.to_fuzzy_refine,
            },
          },
        },
      },
    })
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "live_grep_args")

    local find_git_root = require("doriconfig.utils").find_git_root

    -- Custom live_grep function to search in git root
    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        require("telescope").extensions.live_grep_args.live_grep_args({
          cwd = git_root,
        })
      end
    end

    local function find_files_git_root(hidden_param)
      local git_root = find_git_root()
      local hidden = hidden_param or false
      if git_root then
        require("telescope.builtin").find_files({
          cwd = git_root,
          hidden = hidden,
        })
      end
    end

    local function find_hidden_files_git_root()
      find_files_git_root(true)
    end

    vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

    -- See `:help telescope.builtin`
    local telescope_builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>?", telescope_builtin.oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader>sb", telescope_builtin.buffers, { desc = "[ ] Find existing [B]uffers" })
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>gf", telescope_builtin.git_files, { desc = "Search [G]it [F]iles" })
    vim.keymap.set("n", "<leader>f", find_files_git_root, { desc = "Search [F]iles" })
    vim.keymap.set("n", "<leader>F", find_hidden_files_git_root, { desc = "Search hidden [F]iles" })
    vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader><space>", live_grep_git_root, { desc = "[S]earch by [G]rep in git root or cwd" })
    vim.keymap.set("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", telescope_builtin.resume, { desc = "[S]earch [R]esume" })
  end,
}
