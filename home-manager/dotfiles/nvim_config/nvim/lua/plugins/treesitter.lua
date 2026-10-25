-- parsers in addition to LazyVim defaults
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cmake",
        "cpp",
        "fish",
        "go",
        "haskell",
        "java",
        "kotlin",
        "nix",
        "typst",
      },
    },
  },
}

