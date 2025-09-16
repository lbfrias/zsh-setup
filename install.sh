#!/bin/bash

git clone https://github.com/lbfrias/zsh-setup.git
cd zsh-setup
chmod +x setup.sh
./setup.sh &&
echo "Performing cleanup..."
cd ..
rm -rf zsh-setup
