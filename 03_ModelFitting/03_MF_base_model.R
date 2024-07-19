source("utils/utils.R")

logreg_spec = logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

logreg_wf = workflow() %>%
  add_model(logreg_spec) %>%
  add_recipe(base_recipe)

logreg_fit = fit_standard_wf(logreg_wf)
plot_extract_feature_importance(logreg_fit$fit)