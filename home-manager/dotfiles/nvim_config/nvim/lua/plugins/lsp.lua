-- nvim configuration for LSPs, provide executables in dev shells.
local servers = {
  bashls = "bash-language-server",
  clangd = "clangd",
  cmake = "cmake-language-server",
  fish_lsp = "fish-lsp",
  gopls = "gopls",
  hls = "haskell-language-server-wrapper",
  jdtls = "jdtls",
  kotlin_language_server = "kotlin-language-server",
  lua_ls = "lua-language-server",
  nil_ls = "nil",
  pyright = "pyright-langserver",
  taplo = "taplo",
  tinymist = "tinymist",
  ts_ls = "typescript-language-server",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for server, executable in pairs(servers) do
        opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, {
          mason = false,
          enabled = vim.fn.executable(executable) == 1,
        })
      end
    end,
  },
}

