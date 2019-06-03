#! /usr/bin/env bash
# This file is loaded when opening a non login shell
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# exit if not interactive
[[ $- != *i* ]] && return


if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi


# Source local Configs
if [[ -d ~/.config/bashrc.d && -r ~/.config/bashrc.d && -x ~/.config/bashrc.d ]]; then
  for file in ~/.config/bashrc.d/*.sh; do
     [[ -f "${file}" && -r "${file}" ]] && source "${file}"
  done
fi
