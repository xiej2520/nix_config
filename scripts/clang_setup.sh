#!/bin/bash

if [ -z "$1" ]; then
    read -p "Enter action (install/uninstall/link/unlink): " action
else
    action=$1
fi

if [ -z "$2" ]; then
    read -p "Enter LLVM version: " version
else
    version=$2
fi

if [ -z "$version" ]; then
    echo "No version selected, using 21"
    version=21
fi

case "$action" in
    "install")
        echo "Installing LLVM version $version"
        read -p "Press enter to download and run https://apt.llvm.org/llvm.sh"

        sudo apt-get update
        wget https://apt.llvm.org/llvm.sh
        chmod +x llvm.sh
        sudo ./llvm.sh $version all
    ;;
    "uninstall")
        echo "Uninstalling LLVM packages"

        PKG="clang-$version lldb-$version lld-$version clangd-$version"
        PKG="$PKG clang-tidy-$version clang-format-$version clang-tools-$version llvm-$version-dev lld-$version lldb-$version llvm-$version-tools libomp-$version-dev libc++-$version-dev libc++abi-$version-dev libclang-common-$version-dev libclang-$version-dev libclang-cpp$version-dev libunwind-$version-dev"
        PKG="$PKG libclang-rt-$version-dev libpolly-$version-dev"
        sudo apt remove $PKG
        sudo apt autoremove
    ;;
    "link")
        echo "Setting symbolic links"
        sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang-$version 100
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$version 100
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$version 100
        sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-$version 100
        sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-$version 100
        sudo update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-$version 100
        sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-$version 100
        sudo update-alternatives --install /usr/bin/lld lld /usr/bin/lld-$version 100
        sudo update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-$version 100
    ;;
    "unlink")
        echo "Removing symbolic links"
        sudo update-alternatives --remove cc           /usr/bin/clang-$version
        sudo update-alternatives --remove clang        /usr/bin/clang-$version
        sudo update-alternatives --remove clang++      /usr/bin/clang++-$version
        sudo update-alternatives --remove c++          /usr/bin/clang++-$version
        sudo update-alternatives --remove clang-format /usr/bin/clang-format-$version
        sudo update-alternatives --remove clang-tidy   /usr/bin/clang-tidy-$version
        sudo update-alternatives --remove clangd       /usr/bin/clangd-$version
        sudo update-alternatives --remove lld          /usr/bin/lld-$version
        sudo update-alternatives --remove lldb         /usr/bin/lldb-$version
    ;;
    *)
        echo "'$action' is invalid action"
esac


echo "Displaying symbolic links"
sudo update-alternatives --display cc
sudo update-alternatives --display clang
sudo update-alternatives --display clang++
sudo update-alternatives --display c++
sudo update-alternatives --display clang-format
sudo update-alternatives --display clang-tidy
sudo update-alternatives --display clangd
sudo update-alternatives --display lld
sudo update-alternatives --display lldb

echo "Done!"
