#!/bin/bash

git clone https://github.com/lbfrias/zsh-setup.git
cd zsh-setup
chmod +x setup.sh
echo "Running setup.sh from $(pwd)"
./setup.sh
