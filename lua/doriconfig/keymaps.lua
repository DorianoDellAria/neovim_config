local function map(mode, key, action, opts)
    vim.keymap.set(mode, key, action, opts)
end

-- No highlight
map("n", "<leader>,", ":noh<CR>", { silent = true })

-- Dealing with wordwrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })

-- Diagnosis
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- Move lines
map("n", "<A-j>", "<Esc>:m .+1<CR>", { silent = true })
map("n", "<A-k>", "<Esc>:m .-2<CR>", { silent = true })

map("v", "<A-j>", ":m .+1<CR>==", { silent = true })
map("v", "<A-k>", ":m .-2<CR>==", { silent = true })

map("x", "<A-j>", ":move '>+1<CR>gv-gv", { silent = true })
map("x", "<A-k>", ":move '<-2<CR>gv-gv", { silent = true })

-- Stay in indent mode
map("v", ">", ">gv", { silent = true })
map("v", "<", "<gv", { silent = true })

-- Clipboard
map({ "n", "v", "x" }, "<leader>y", '"+y', { silent = true, desc = "yank into the system clipboard" })
-- map("n", "<leader>y", "\"+yy", { silent = true })

map({ "n", "v", "x" }, "<leader>d", '"+d', { silent = true, desc = "delete into the system clipboard" })
-- map("n", "<leader>d", "\"+dd", { silent = true })

map("n", "<leader>p", '"+p', { silent = true, desc = "paste from the system clipboard" })

local function cnoreab(lhs, rhs)
    local command = 'cnoreabbrev %s %s'

    vim.cmd(command:format(lhs, rhs))
end

cnoreab('W', 'w')

cnoreab('Q', 'q')

cnoreab('Wq', 'wq')
cnoreab('wQ', 'wq')
cnoreab('WQ', 'wq')

cnoreab('Wa', 'wa')
cnoreab('wA', 'wa')
cnoreab('WA', 'wa')
