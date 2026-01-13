vim.keymap.set("n", "<Esc>", ":w<CR>") -- save file
vim.keymap.set("n", "<leader>d", "yyp", { desc = "[D]uplicate line" })
vim.keymap.set({ "n", "v" }, "<C-Right>", "<End>")
vim.keymap.set("i", "<C-Right>", "<C-o>$")
vim.keymap.set({ "n", "v", "i" }, "<C-Left>", "<Home>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "[R]ename" })
vim.keymap.set({ "n", "i", "v" }, "<C-j>", "]m")
vim.keymap.set({ "n", "i", "v" }, "<C-k>", "[m")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({ "i", "v", "n" }, "<C-h>", "<Home>")
vim.keymap.set({ "i", "v", "n" }, "<C-l>", "<End>")

local mappings = {
	Left = { cmd = "h", desc = "Move window left" },
	Down = { cmd = "j", desc = "Move window down" },
	Up = { cmd = "k", desc = "Move window up" },
	Right = { cmd = "l", desc = "Move window right" },
}

for key, info in pairs(mappings) do
	vim.keymap.set("n", "<leader><" .. key .. ">", "<C-\\><C-n><C-w>" .. info.cmd, { silent = true, desc = info.desc })
end

-- Diagnostics
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float({
		border = "rounded",
		max_width = 80,
		source = true,
	})
end, { desc = "Show diagnostic [E]rror" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
