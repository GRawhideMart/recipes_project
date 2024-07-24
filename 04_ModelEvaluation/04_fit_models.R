source("~/Documents/Personal projects/recipes/utils/utils.R")

# Base logistic regression -> baseline model
baseline = fit_best_workflow("base_logreg")

# Comparison models
comparison = recipe_models_set %>% 
  select(wflow_id) %>% 
  filter(wflow_id != "base_logreg") %>% 
  pull(wflow_id) %>% 
  unique() %>% 
  set_names() %>%
  map(~ fit_best_workflow(.x)) %>%
  enframe(name="id", value="fitted_workflow")

