local angular_workspace = require("angular_workspace")

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.html",
	callback = function(args)
		if angular_workspace.is_angular_buffer(args.buf) then
			vim.bo[args.buf].filetype = "htmlangular"
		end
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
