#!/bin/bash

echo "Installing dots..."
set -o xtrace
cp home/.bashrc ~
cp home/.tmux.conf ~
cp home/.vimrc ~
mkdir -p ~/.config/nvim
cp home/.config/nvim/init.vim ~/.config/nvim
mkdir -p ~/bin
echo "export PATH=\"$HOME/bin:\$PATH\"" >> ~/.bashrc
cp bin/* "$HOME/bin"
set +o xtrace
