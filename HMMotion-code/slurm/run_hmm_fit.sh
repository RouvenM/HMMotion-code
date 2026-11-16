#!/bin/bash -l
# HMM fit (02_HMM_model_fitting.R): about 2 days of setup (tape) before
# the first iteration plus about 5 days of optimisation, so it runs as one job on
# partition ultralong. Submit from the project directory (the repository root with R/,
# rawdata/, results/):
#
#   sbatch slurm/run_hmm_fit.sh
#
# If it ever hits the time limit, submitting it again continues from
# results/mod_checkpoint.rds (after repeating the setup).
#SBATCH --job-name=hmmotion_hmm
#SBATCH --partition=ultralong
#SBATCH --time=14-00:00:00
#SBATCH --mem=200G
#SBATCH --cpus-per-task=1
#SBATCH --output=hmmotion_hmm_%j.out

# project root = directory sbatch was called from (needs .here or the .Rproj file)
cd "$SLURM_SUBMIT_DIR"
module load R  # adjust to the R module of your cluster

Rscript R/02_HMM_model_fitting.R
