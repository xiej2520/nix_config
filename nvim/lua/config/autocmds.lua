-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")


local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("wrap_move"),
  -- these files have wrap and spellcheck turned on
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    local map = vim.keymap.set
    -- flip the behavior of 0/g0 and $/g$
    map({ "n", "x" }, "0", "g0", { desc = "Beginning of visible line", silent = true })
    map({ "n", "x" }, "g0", "0", { desc = "Beginning of line", silent = true })

    map({ "n", "x" }, "$", "g$", { desc = "End of visible line", silent = true })
    map({ "n", "x" }, "g$", "$", { desc = "End of line", silent = true })
  end,
})
