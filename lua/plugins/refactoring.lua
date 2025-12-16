return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	config = function()
		require("refactoring").setup()
		vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "[R]efactor [E]xtract" })
		vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "[R]efactor extract to [F]ile" })
		vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "[R]efactor extract [V]ar" })
		vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "[R]efactor [I]nline var" })
		vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "[R]efactor [I]nline Func" })
		vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "[R]efactor extract [B]lock" })
		vim.keymap.set(
			"n",
			"<leader>rbf",
			":Refactor extract_block_to_file",
			{ desc = "[R]efactor extract [B]lock to [F]ile" }
		)
	end,
}
