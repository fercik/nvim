vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.html",
	callback = function()
		vim.bo.filetype = "htmlangular"
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.mdc",
	callback = function()
		vim.bo.filetype = "markdown"
	end,
})

-- Auto-refresh files changed outside Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File was updated on disk and reloaded.", vim.log.levels.INFO)
	end,
})
