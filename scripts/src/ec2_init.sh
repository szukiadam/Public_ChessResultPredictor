#!/bin/bash

sudo yum -y install python3-pip
sudo yum -y install tmux
yes | sudo pip3 install python-chess
sudo yum -y install git
git clone https://github.com/fsmosca/chess-artist.git