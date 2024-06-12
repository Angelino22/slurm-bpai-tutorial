#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=02:00:00
#SBATCH -N 1
#SBATCH --array=1-5

# Ensure the directory exists and is empty
mkdir -p $TMPDIR/ava940

# Copy all necessary files excluding .git and anaconda3 directories
rsync -av --exclude='.git' --exclude='anaconda3' /var/scratch/ava940/ $TMPDIR/ava940/

# Navigate to the directory containing the Python script
cd $TMPDIR/ava940/DQN/cleanrlangel/cleanrl || exit 1

# Debugging output to ensure we are in the correct directory
pwd
ls -l

# Set environment and execute the Python script
module load gnu9/9.4.0
conda init
conda activate bpaiAngel
seeds=(123 456 789 101112 131415)
seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]}
python Experiments \
    --seed $seed \
    --env-id Foozpong_v3 \
    --total-timesteps 1000 \
    --track \
    --wandb_project_name Foozy \
    --capture_video

# Cleanup: Remove the copied directory after the experiment
rm -rf $TMPDIR/ava940/