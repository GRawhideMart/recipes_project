logreg_spec = logistic_reg(penalty = tune(), mixture = tune()) %>%
  set_engine("glmnet") %>%
  set_mode("classification")

rf_spec = rand_forest(trees = tune(), min_n = tune(), mtry = sqrt(floor(0.67 * 17)) + 1) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

xgb_spec <- boost_tree(mtry = sqrt(floor(0.67 * 17)) + 1, trees = tune(), learn_rate = tune()) %>%
  set_engine("xgboost") %>%
  set_mode("classification")