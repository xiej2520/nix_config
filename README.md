# nvim Config

## LazyVim nvim config

Using *lua*

1. Run `install.sh`

On windows, install nvim, copy `nvim` to `C:/Users/<user>/AppData/Local/nvim`

Overview

* Uses LazyVim and lazy.nvim package
* onedark theme
* mason + treesitter
* rust.lua plugins for rust

## nvim + coc config

In `nvim-old` folder

1. Move `init.vim` and `coc-settings.json` into the nvim config folder
   * `C:/Users/<user>/AppData/Local/nvim`
   * `/home/<user>/.config/nvim`
2. Install vim-plug
   * Windows:

    ```Powershell
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
    ```

    * Linux:

    ```Bash
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    ```

3. `:source $MYVIMRC`
4. `:PlugInstall`
5. Install coc.nvim dependencies:

   ```Bash
   cd ~/.local/share/nvim/plugged/coc.nvim/
   npm install
   ```

6. Install coc.nvim plugins

`:CocInstall coc-clangd coc-java coc-python coc-tsserver coc-json coc-html coc-css
coc-markdownlint coc-markdown-preview-enhanced coc-webview`
