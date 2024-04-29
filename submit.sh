#!/bin/sh
#SBATCH --time=00:15:00
#SBATCH -N 1

cp -r $HOME/slurm-bpai-tutorial/python $TMPDIR/ava940
cd $TMPDIR/ava940/python
python Trial.py
