#! /usr/bin/env bash
#This file is run anytime you log in to the system (ie via ssh, or vnc)
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

PATH=$PATH:$HOME/bin

export PATH
