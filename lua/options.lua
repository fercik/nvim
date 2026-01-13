vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.cmd("filetype indent on")
vim.opt.swapfile = false
vim.opt.clipboard:append("unnamedplus")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "rounded"

vim.diagnostic.config({ virtual_text = true })

vim.opt.autoread = true

vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")
