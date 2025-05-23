vim.api.nvim_create_user_command("CopyLineRef", function()
	local file = vim.fn.expand("%")
	local line = vim.fn.line(".")
	local ref = string.format("%s#L%d", file, line)
	vim.fn.setreg("+", ref) -- copy to system clipboard
	print("Copied: " .. ref)
end, {})
