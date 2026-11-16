#!/bin/bash -l
# Cross-fitting of the coverage models (04_coverage_models_crossfit.R) as a SLURM array:
# one of the 50 repetitions per task, saved to results/crossfit_reps/rep_XX.rds.
# Submit from the project directory with:
#   sbatch slurm/run_crossfit_array.sh
# When all tasks are done, combine them into results/zvm_crossfit_runs.rds:
#   sbatch --dependency=afterok:<ARRAY_JOBID> --export=ALL,HMMOTION_COMBINE=1 \
#          --array=1 --time=00:30:00 R/run_crossfit_array.sh
# (with HMMOTION_COMBINE=1 the script ignores the task id and only combines)
#SBATCH --job-name=hmmotion_cf
#SBATCH --partition=long
#SBATCH --time=2-00:00:00
#SBATCH --mem=6G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-50
#SBATCH --output=hmmotion_cf_%A_%a.out

cd "$SLURM_SUBMIT_DIR"
module load R  # adjust to the R module of your cluster

if [ "$HMMOTION_COMBINE" = "1" ]; then
  unset SLURM_ARRAY_TASK_ID
fi
Rscript R/04_coverage_models_crossfit.R
