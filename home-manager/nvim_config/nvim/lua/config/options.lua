-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = false
opt.endofline = false
opt.fixendofline = false
opt.listchars = "space:·,lead:.,tab:>\\|,trail:~,extends:>,precedes:<"
opt.colorcolumn = "80,100,120"

opt.conceallevel = 0
opt.cursorcolumn = true
