#!/bin/bash
#SBATCH -J genppl_bamdlm                # Job name
#SBATCH -o watch_folder/%x_%j.out     # log file (out & err)
#SBATCH -e watch_folder/%x_%j.err     # log file (out & err)
#SBATCH -N 1                          # Total number of nodes requested
#SBATCH --get-user-env                # retrieve the users login environment
#SBATCH --mem=32G                  # server memory requested (per node)
#SBATCH -t 960:00:00                  # Time limit (hh:mm:ss)
#SBATCH --partition=gpu          # Request partition
#SBATCH --constraint="[a5000|a6000|a100|3090]"
#SBATCH --constraint="gpu-mid|gpu-high"
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1                  # Type/number of GPUs needed
#SBATCH --open-mode=append            # Do not overwrite logs
#SBATCH --requeue                     # Requeue upon preemption

LENGTH=$1
SEED=$2
BLOCK_SIZE=$3

srun python -u main.py \
    loader.eval_batch_size=1 \
    model=small \
    algo=bamdlm \
    algo.T=5000 \
    algo.backbone=hf_dit \
    data=openwebtext-split \
    model.length=$LENGTH \
    block_size=$BLOCK_SIZE \
    wandb=null \
    mode=sample_eval \
    eval.checkpoint_path=kuleshov-group/bamdlm-owt-block_size${BLOCK_SIZE} \
    model.attn_backend=sdpa \
    seed=$SEED \
    sampling.nucleus_p=0.9 \
    sampling.logdir=$PWD/sample_logs/samples_bamdlm_len${LENGTH}_blocksize${BLOCK_SIZE}