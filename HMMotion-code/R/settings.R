######################################################################################
#### Settings shared by the pipeline scripts
######################################################################################

# Defender reaction lag in frames (10 Hz) between attacker and defender
# positions, chosen by AIC in 02a_lag_and_delta_selection.R. Lags 4 and 5
# (0.4-0.5 s) are close and their order depends on the subsample of plays;
# Lag 4 is used throughout.
HMM_LAG <- 4

# HMM input file of a week written by 01 (folder: rawdata/, or the one set with
# the environment variable HMMOTION_DATA_DIR, e.g. for older data)
hmm_file <- function(week){
  here::here(Sys.getenv("HMMOTION_DATA_DIR", "rawdata"), paste0("final_preprocessed_week_", week, "_lag", HMM_LAG, ".csv"))
}
