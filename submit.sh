#!/bin/sh
#SBATCH --time=00:15:00
#SBATCH -N 1

cp -r $HOME/slurm-bpai-tutorial/python $Angel
cd $Angel/python
python script.py
