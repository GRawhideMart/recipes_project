# Recipe that builds on the intuition of EDA
base_recipe = recipe(high_traffic ~ ., data = recipes_train) %>%
  # Remove the ID column
  step_rm(recipe) %>% 
  # Dummify categorical variables
  step_dummy(all_nominal_predictors()) %>%
  # Apply min-max transform to numeric variables
  step_range(calories, carbohydrate, sugar, protein, min = 0, max = 1) %>% 
  # Deal with class imbalance
  themis::step_smote(all_outcomes())

onlycat_recipe = base_recipe %>%
  step_rm(sugar, carbohydrate, protein, calories, starts_with("servings_")) 

asinh_recipe = recipe(high_traffic ~ ., data = recipes_train) %>%
  # Remove the ID column
  step_rm(recipe) %>% 
  # Apply asinh transform to numeric variables
  step_mutate(
    across(
      .cols = where(is.numeric),
      .fns = ~asinh(.x)
    )
  ) %>%
  # Dummify categorical variables
  step_dummy(all_nominal_predictors()) %>%
  # Apply min-max transform to numeric variables
  step_range(calories, carbohydrate, sugar, protein, min = 0, max = 1) %>% 
  # Deal with class imbalance
  themis::step_smote(all_outcomes())

log_recipe = recipe(high_traffic ~ ., data = recipes_train) %>%
  # Remove the ID column
  step_rm(recipe) %>% 
  # Apply asinh transform to numeric variables
  step_mutate(
    across(
      .cols = where(is.numeric),
      .fns = ~log(1+.x)
    )
  ) %>%
  # Dummify categorical variables
  step_dummy(all_nominal_predictors()) %>%
  # Apply min-max transform to numeric variables
  step_range(calories, carbohydrate, sugar, protein, min = 0, max = 1) %>% 
  # Deal with class imbalance
  themis::step_smote(all_outcomes())

pca_recipe = asinh_recipe %>%
  step_pca(sugar, carbohydrate, protein, calories, num_comp = 2)