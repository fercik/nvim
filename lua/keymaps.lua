vim.keymap.set("n", "<Esc>", ":w<CR>") -- save file
vim.keymap.set("n", "<leader>d", "yyp") -- duplicate current line
vim.keymap.set({'n', 'v'}, '<C-Right>', '<End>')
vim.keymap.set('i', '<C-Right>', '<C-o>$')
vim.keymap.set({'n', 'v', 'i'}, '<C-Left>', '<Home>')
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")
vim.keymap.set("n", "<leader>r", '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set({"n", "i", "v"}, "<C-j>", "]m")
vim.keymap.set({"n", "i", "v"}, "<C-k>", "[m")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({"i", "v", "n"}, "<C-h>", "<Home>")
vim.keymap.set({"i", "v", "n"}, "<C-l>", "<End>")
