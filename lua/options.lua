vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set backspace=indent,eol,start")
vim.cmd("set autoindent")
vim.cmd("set smartindent")
vim.cmd(":filetype indent on")
vim.cmd("set number")
vim.opt.guicursor = ""
vim.opt.swapfile = false
vim.opt.clipboard:append("unnamedplus")
vim.opt.number = true
vim.opt.relativenumber = true

vim.diagnostic.config({ virtual_text = true })

vim.filetype.add({
  extension = {
    ["component.html"] = "html",
  },
})
