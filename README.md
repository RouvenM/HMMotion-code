# HMMotion: latent guarding assignments and defensive coverage schemes

Code for the paper *Integrating Unsupervised and Supervised Learning for the Prediction and Interpretation of Defensive Schemes in American Football* by Rouven Michels, Robert Bajons and Jan-Ole Fischer.

A non-homogeneous hidden Markov model (HMM) with random effects for positions, teams and plays infers from player tracking data which offensive player each defender guards during pre-snap motion. Features derived from the posterior state probabilities are used, together with pre-motion and naive post-motion features, in elastic net and XGBoost models that predict whether the defense plays man or zone coverage, and are assessed with Generalized Covariance Measure (GCM) tests.

## Data

The analysis uses the data of the [NFL Big Data Bowl 2025](https://www.kaggle.com/competitions/nfl-big-data-bowl-2025) (first nine weeks of the 2022 NFL season), which were made publicly available on Kaggle for the competition. The data are not part of this repository. Place the following files in a folder `rawdata/` in the repository root:

```
rawdata/tracking_week_1.csv ... tracking_week_9.csv
rawdata/plays.csv
rawdata/players.csv
rawdata/games.csv
```

All results are written to `results/` (created automatically). Paths are resolved with the `here` package relative to the repository root.

## Requirements

R (>= 4.4) with the packages `dplyr`, `tidyr`, `tidyverse`, `stringr`, `vroom`, `here`, `RTMB`, `TMB`, `LaMa`, `glmnet`, `glmnetUtils`, `xgboost`, `ranger`, `pROC`, `comets`, `ggplot2`, `ggpubr`, `ggtext`, `ggimage`, `scales`, `Cairo`, `nflplotR`, `nflreadr`, `gt`, `gtExtras`, `reactable`, `reactablefmtr` and `magick`.

## Scripts

Run the scripts in `R/` in this order:

| Script | Content |
|---|---|
| `settings.R` | Shared settings (lag of the HMM, input files); sourced by the other scripts |
| `01_preprocessing.R` | Pre-processing of the tracking data: HMM input per week and pre- and post-motion features |
| `02a_lag_and_delta_selection.R` | Selection of the lag (AIC) and of the sharpness of the initial distribution (profile likelihood) with a homogeneous HMM |
| `02_HMM_model_fitting.R` | Fit of the non-homogeneous HMM with random effects (Laplace approximation with `RTMB`) |
| `03_create_data_HMM.R` | Posterior state probabilities, HMM features and the data set for the coverage models (uses `hmm_posterior_features.R`) |
| `04_coverage_models_crossfit.R` | Elastic net and XGBoost coverage models, 50 repetitions of 5-fold cross-fitting (uses `zvm_models.R`) |
| `05_team_analysis.R` | Leave-one-team-out comparison of the pre-motion and post-motion models |
| `06_gcm_tests.R` | GCM tests of the HMM features |
| `07_paper_numbers_figures.R` | All numbers, tables and figures of the paper (uses `fig_gcm.R`) |
| `fig_preprocessing.R`, `fig_HMM_expl.R` | Figures 1 and 2 of the paper |

## Computation

The HMM in `02_HMM_model_fitting.R` is fitted to about 1.2 million observations with 4,344 play-level random effects. On a single core, the setup of the Laplace approximation takes several days and the model needs about 200 GB of memory, so it was run on a computing cluster (`slurm/run_hmm_fit.sh`). The cross-fitting in `04_coverage_models_crossfit.R` was run as an array job with one repetition per task (`slurm/run_crossfit_array.sh`). All other scripts run on a standard computer. Most scripts have a quick test mode (see the comments at the top of each script).

Once fitted, the HMM can be applied to new plays at negligible cost (see the discussion in the paper).
