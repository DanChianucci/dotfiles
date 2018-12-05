#! /usr/bin/env bash
# This file is loaded when opening a non login shell
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# exit if not interactive
[[ $- != *i* ]] && return

# Source local Configs
if [[ -d ~/bash_config/bashrc.d && -r ~/bash_config/bashrc.d && -x ~/bash_config/bashrc.d ]]; then
  for file in ~/bash_config/bashrc.d/*.sh; do
     [[ -f "${file}" && -r "${file}" ]] && source "${file}"
  done
fi
