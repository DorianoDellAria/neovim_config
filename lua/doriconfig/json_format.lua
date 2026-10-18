vim.api.nvim_create_user_command("JsonFormat", function(opts)
	if vim.fn.executable("jq") == 0 then
		vim.notify("jq is not installed", vim.log.levels.ERROR)
		return
	end

	local indent = opts.args ~= "" and opts.args or "2"
	if not indent:match("^%d+$") then
		vim.notify("Indent must be a number", vim.log.levels.ERROR)
		return
	end

	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local result = vim.system({ "jq", "--indent", indent, "." }, { stdin = lines, text = true }):wait()

	if result.code ~= 0 then
		vim.notify(vim.trim(result.stderr or "jq failed"), vim.log.levels.ERROR)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local formatted = vim.split(result.stdout, "\n", { plain = true })
	if formatted[#formatted] == "" then
		table.remove(formatted)
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
	pcall(vim.api.nvim_win_set_cursor, 0, { math.min(cursor[1], #formatted), cursor[2] })
end, { nargs = "?", desc = "Format JSON buffer with jq" })

vim.keymap.set("n", "<leader>jf", "<cmd>JsonFormat<cr>", { desc = "[J]son [F]ormat" })
