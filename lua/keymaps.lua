vim.keymap.set("n", "<Esc><Esc>", ":w<CR>") -- save file
vim.keymap.set("n", "<C-d>", "yyp") -- duplicate current line
vim.keymap.set("n", "<C-v>", '"+p') -- paste
vim.keymap.set('v', '<C-v>', '"+p') -- paste
vim.keymap.set('v', '<C-c>', '"+y') -- copy
vim.keymap.set('v', '<C-x>', '"+d') -- cut
vim.keymap.set({'n', 'v'}, '<C-Right>', '<End>')
vim.keymap.set('i', '<C-Right>', '<C-o>$')
vim.keymap.set({'n', 'v', 'i'}, '<C-Left>', '<Home>')
