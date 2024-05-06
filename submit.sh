#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=15
#SBATCH -N 1
#SBATCH --array=1-5

module load gnu9/9.4.0

conda init
conda activate anaconda-test

which python

cd /var/scratch/ava940/cleanrl/

seeds=(123 456 789 101112 131415)

seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]} 
python cleanrl/ppo.py \
    --seed $seed \
    --env-id CartPole-v0 \
    --total-timesteps 50000
