local g = vim.g
local o = vim.o

-- Set leader key
g.mapleader = " "
g.maplocalleader = " "

-- Set coloerscheme
o.termguicolors = true

-- Set line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 2

-- Set tab
o.expandtab = true
o.smarttab = true
o.autoindent = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.wrap = true

-- Set mouse
o.mouse = "a"

-- Set case
o.ignorecase = true
o.smartcase = true

-- Set split behaviour
o.splitbelow = true
o.splitright = true

-- Set scrolloff
o.scrolloff = 8

o.swapfile = false

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
