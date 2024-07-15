#!/bin/bash
#SBATCH --job-name=cleanrltest
#SBATCH --time=01:00:00
#SBATCH -N 1
#SBATCH --array=1-5


WORK_DIR="$TMPDIR/ava940"
SAVE_DIR="/var/scratch/ava940/saved_models_2"
PROJECT_DIR="$WORK_DIR/DQN/cleanrlangel/cleanrl"

mkdir -p $WORK_DIR
mkdir -p $SAVE_DIR

rsync -av --exclude='.git' --exclude='anaconda3' /var/scratch/ava940/ $WORK_DIR/


cd $PROJECT_DIR || exit 1

module load gnu9/9.4.0
conda init
conda activate bpaiAngel

seeds=(123 456 789 101112 131415)
seed=${seeds[$SLURM_ARRAY_TASK_ID - 1]}


python Validation_2.py \
    --seed $seed \
    --env-id Foozpong_v3 \
    --total-timesteps 1000000 \
    --track \
    --wandb_project_name UNVALIDATED \
    --save_path /var/scratch/ava940/saved_models_2/Foozpong_v3__Experiment__131415__1720294140/Experiment_first_0.cleanrl_model \
    --wandb_entity Angelrvo2002 \

RUNS_DIR="$PROJECT_DIR/runs"
if [ -d "$RUNS_DIR" ]; then
    rsync -av "$RUNS_DIR/" "$SAVE_DIR/"
fi

rm -rf $WORK_DIR
