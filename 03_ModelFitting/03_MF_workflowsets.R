source("03_ModelFitting/03_MF_recipes.R")
source("03_ModelFitting/03_MF_model_specs.R")

set.seed(1993)

recipe_models_set = workflow_set(
  preproc = list(
    base = base_recipe,
    onlycat = onlycat_recipe,
    log = log_recipe
  ),
  models = list(
    logreg = logreg_spec,
    rf = rf_spec,
    xgb = xgb_spec
  ),
  cross = TRUE
) %>%
  anti_join(tibble(
      wflow_id = c("log_rf", "log_xgb") # The random forest and boosting methods
                                        # do not need normalization
    ), by = "wflow_id"
  )

recipe_models_set = recipe_models_set %>%
  workflow_map(
    "tune_bayes",
    seed = 1993,
    resamples = recipes_folds,
    iter = 8,
    metrics = metric_set(accuracy, roc_auc),
    initial = 36,
    objective = exp_improve(trade_off = expo_decay(8, start_val = 1, limit_val = 0, slope = 1/8)),
    verbose = TRUE,
    control = control_bayes(save_pred = TRUE, save_workflow = TRUE, verbose = TRUE),
  )

rank_results(recipe_models_set, rank_metric = "accuracy", select_best = TRUE) %>%
  write_csv("data/model_comparison_results.csv")