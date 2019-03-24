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
                xregress           \
                riviera/2017.02.99  &> /dev/null
    module list
  fi
fi
