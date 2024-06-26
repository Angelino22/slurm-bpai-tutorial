#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=00:15:00
#SBATCH -N 1
#SBATCH --array=1-5

# Directories and paths
WORK_DIR="$TMPDIR/ava940"
SAVE_DIR="/var/scratch/ava940/saved_models"

# Create necessary directories
mkdir -p $WORK_DIR
mkdir -p $SAVE_DIR

# Sync files to the temporary directory
rsync -av --exclude='.git' --exclude='anaconda3' /var/scratch/ava940/ $WORK_DIR/

# Navigate to the project directory
cd $WORK_DIR/DQN/cleanrlangel/cleanrl || exit 1

# Load the module and activate the conda environment
module load gnu9/9.4.0
conda init
conda activate bpaiAngel

# Set the seed array
seeds=(123 456 789 101112 131415)
seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]}

# Run the Python script with necessary arguments
python Experiments_2.py \
    --seed $seed \
    --env-id Foozpong_v3 \
    --total-timesteps 5000 \
    --track \
    --wandb_project_name TRAINED \
    --wandb_entity Angelrvo2002 \
    --capture_video \
    --save_model

# Copy the saved model files back to the main storage
rsync -av $WORK_DIR/DQN/cleanrlangel/cleanrl/runs/ $SAVE_DIR/

# Clean up the temporary directory
rm -rf $WORK_DIR
