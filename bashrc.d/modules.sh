#! /usr/bin/env bash
if command -v module > /dev/null; then
  if [[ "$-" == *i* ]] ; then  #Only Load during Interactive Shells
    module use ~/.config/modulefiles
    module purge &> /dev/null
    module load xtools/local       \
                xregmap/local      \
                xcov/local         \
                xtest/local        \
                local_bin/local    \
                slurm              \
                xcm                \
                xregress/beta
    module list
  fi
fi
