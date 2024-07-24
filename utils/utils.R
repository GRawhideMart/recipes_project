library(vip)
require(tidyverse)
require(tidymodels)

fit_standard_wf = function(wf) {
  fit_wf = wf %>% fit(data = recipes_train)
  augmented_wf_train = fit_wf %>% augment(new_data = recipes_train)
  augmented_wf_test = fit_wf %>% augment(new_data = recipes_test)
  
  list(
    fit = fit_wf,
    aug_train = augmented_wf_train,
    aug_test = augmented_wf_test
  )
}

extract_feature_importance = function(fitted_wf) {
  imp = fitted_wf %>% extract_fit_parsnip() %>% vi()
  imp %>% rename(Feature = Variable, Importance = Importance)
}

plot_extract_feature_importance = function(fitted_wf) {
  fitted_wf %>% 
    extract_fit_parsnip() %>% 
    vip() %>% 
    print()
}

fit_best_workflow = function(id) {
  wf = recipe_models_set %>% extract_workflow(id = id)
  best_results = recipe_models_set %>% extract_workflow_set_result(id = id) %>% select_best(metric = 'accuracy')
  wf = wf %>% finalize_workflow(best_results) %>% fit(data = recipes_train)
  
  wf
}

# Import RColorBrewer for color imputation
library(RColorBrewer)

calculate_metrics = function(augmented_df, id) {
  acc = augmented_df %>% accuracy(high_traffic, .pred_class) %>% pull(.estimate) # Accuracy
  sensitivity = augmented_df %>% sens(high_traffic, .pred_class) %>% pull(.estimate) # Sensitivity
  specificity = augmented_df %>% spec(high_traffic, .pred_class) %>% pull(.estimate) # Specificity
  precision = augmented_df %>% precision(high_traffic, .pred_class) %>% pull(.estimate) # Precision
  recall = augmented_df %>% recall(high_traffic, .pred_class) %>% pull(.estimate) # Recall
  roc_auc = augmented_df %>% roc_auc(high_traffic, .pred_0) %>% pull(.estimate) # ROC AUC
  roc = augmented_df %>% roc_curve(high_traffic, .pred_0) %>% nest
  
  # Generate the metrics dataframe
  metrics = tibble(
    model = id,
    accuracy = acc, 
    sensitivity, 
    specificity, 
    precision, 
    recall, 
    roc_auc,
    roc
    ) %>% rename(
      roc_curve = data
    )
  
  metrics
}

plot_roc_curve = function(base_roc, comparison_roc = list(), title = "") {
  # Compute a color list (at least 3)
  colors = brewer.pal(n = max(3, length(comparison_roc)), name = "Set2")
  
  # Compute the baseline plot (equivalent to autoplot)
  plot = ggplot(base_roc, aes(x = 1 - specificity, y = sensitivity)) +
    geom_path() +
    geom_abline(lty = 3) +
    coord_equal() +
    theme_minimal() +
    labs(title = title) +
    theme(plot.title = element_text(hjust = .5))
  
  # If the second argument is not an empty list, add a layer for each ROC curve passed in
  if(length(comparison_roc) != 0) {
    for(i in 1:length(comparison_roc)) {
      plot = plot + 
        geom_path(data = as_tibble(comparison_roc[[i]]), 
                  aes(x = 1 - specificity, y = sensitivity), 
                  color = colors[i], 
                  show.legend = TRUE)
    }   
  }
  plot
}

pull_fitted_wf = function(comparison, id) {
  comparison %>% filter(id==id) %>% pull(fitted_workflow) %>% .[[1]]
}

evaluate_models = function(comparison_models) {
  # Extract workflows and IDs
  workflows = comparison_models$fitted_workflow
  ids <- comparison_models$id
  
  # Iterate and collect metrics, storing ROC curves directly as lists
  results = map2_dfr(workflows, ids, function(workflow, id) {
    augmented_train = workflow %>% augment(new_data = recipes_train)
    augmented_test = workflow %>% augment(new_data = recipes_test)
    
    metrics_train = calculate_metrics(augmented_train, id)
    metrics_test = calculate_metrics(augmented_test, id)
    
    bind_rows(
      metrics_train %>% mutate(set = "train"),
      metrics_test %>% mutate(set = "test")
    )
  })
  
  # Final arrangement
  results %>%
    select(model, set, everything()) %>%
    arrange(model, desc(set))
}