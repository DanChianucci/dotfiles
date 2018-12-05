#! /usr/bin/env bash


if [[ "$-" == *i* ]] ; then  #Only Load during Interactive Shells
  module use ~/bash_config/modulefiles
  module purge &> /dev/null
  module load slurm              \
              xcm                \
              xregress/3.15      \
              riviera/2017.02.99 \
              texlive            \
              xutils/local       \
              xregmap/local      \
              xcov/local         \
              xtest/local        \
              local_bin/local > /dev/null 2>&1
  module list
fi
