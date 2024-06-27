#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=05:00:00
#SBATCH -N 1
#SBATCH --array=1-5

# Directories and paths
WORK_DIR="$TMPDIR/ava940"
SAVE_DIR="/var/scratch/ava940/saved_models_2"
PROJECT_DIR="$WORK_DIR/DQN/cleanrlangel/cleanrl"

# Create necessary directories
mkdir -p $WORK_DIR
mkdir -p $SAVE_DIR

# Sync files to the temporary directory
rsync -av --exclude='.git' --exclude='anaconda3' /var/scratch/ava940/ $WORK_DIR/

# Navigate to the project directory
cd $PROJECT_DIR || exit 1

# Load the module and activate the conda environment
module load gnu9/9.4.0
conda init
conda activate bpaiAngel

# Set the seed array
seeds=(123 456 789 101112 131415)
seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]}

# Run the Python script with necessary arguments
python validation_2.py \
    --seed $seed \
    --env-id Foozpong_v3 \
    --total-timesteps 50000 \
    --track \
    --wandb_project_name UNVALIDATED \
    --save_path /var/scratch/ava940/saved_models_2/Foozpong_v3__Experiment__789__1719503146/
    --wandb_entity Angelrvo2002 \
    --capture_video \
    --save_model

# Check if the runs directory exists
RUNS_DIR="$PROJECT_DIR/runs"
if [ -d "$RUNS_DIR" ]; then
    rsync -av "$RUNS_DIR/" "$SAVE_DIR/"
fi

# Clean up the temporary directory
rm -rf $WORK_DIR
