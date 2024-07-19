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
    vip(aesthetics = list(title = "GCIAO")) %>% 
    print()
}
