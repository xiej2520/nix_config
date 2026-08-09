-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Tab and Shift-Tab indenting in normal and visual mode
map("n", "<Tab>", ">>")
map("n", "<S-Tab>", "<<")
-- stay in visual mode
map("v", "<Tab>", ">gv", { noremap=true })
map("v", "<S-Tab>", "<gv", { noremap=true })
-- Shift-Tab unindents in insert mode
map("i", "<S-Tab>", "<C-d>", { noremap = true })
