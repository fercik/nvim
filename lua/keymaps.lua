vim.keymap.set("n", "<Esc>", ":w<CR>") -- save file
vim.keymap.set("n", "<leader>d", "yyp") -- duplicate current line
vim.keymap.set({'n', 'v'}, '<C-Right>', '<End>')
vim.keymap.set('i', '<C-Right>', '<C-o>$')
vim.keymap.set({'n', 'v', 'i'}, '<C-Left>', '<Home>')
