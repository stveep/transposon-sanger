#!/bin/bash
#PBS -N dutchsendoff
#PBS -l nodes=uv:ppn=8,mem=60gb
#PBS -q aangs
#PBS -m a
#PBS -M spettitt@icr.ac.uk
#PBS -o /home/spettitt/data/grid_pilot/cherry2/pull.out
#PBS -e /home/spettitt/data/grid_pilot/cherry2/pull.err
#PBS -j oe
/home/spettitt/data/grid_pilot/pullout.rb /home/spettitt/data/grid_pilot/cherry2/combined.map

wait
