#!/bin/bash

git clone https://github.com/lbfrias/zsh-setup.git
cd zsh-setup
chmod +x setup.sh
./setup.sh
cd ..
rm -rf zsh-setup
