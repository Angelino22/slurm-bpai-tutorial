#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=00:15:00
#SBATCH -N 1
#SBATCH --array=1-5



mkdir -p $TMPDIR/ava940
rsync -av --exclude='.git' --exclude='anaconda3' /var/scratch/ava940/ $TMPDIR/ava940/
cd $TMPDIR/ava940/DQN/cleanrlangel/cleanrl || exit 1
module load gnu9/9.4.0
conda init
conda activate bpaiAngel
seeds=(123 456 789 101112 131415)
seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]}
python Experiments \
    --seed $seed \
    --env-id Foozpong_v3 \
    --total-timesteps 10000 \
    --track \
    --wandb_project_name FINALPONG_2 \
    --wandb_entity Angelrvo2002\
    --capture_video
rm -rf $TMPDIR/ava940/