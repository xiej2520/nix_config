#!/bin/bash

set -ueo pipefail

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

cp -r nvim ~/.config/nvim

echo "Add /opt/nvim-linux64/bin to PATH (.bashrc)"
