require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.opt.wrap = false
vim.opt.sidescroll = 1

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.list = true
vim.opt.listchars = {
    tab = "▸ ",
    space = "·",
    nbsp = "␣"
}
