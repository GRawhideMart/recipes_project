comparison %>% evaluate_models() %>%
  # deselect the roc_curve vectors
  select(-roc_curve) %>%
  # make the metrics long
  pivot_longer(-c(model, set), names_to = "metric", values_to = "estimate") %>% 
  # Not to clutter the plot, I will focus only on metrics of interest
  filter(metric %in% c("accuracy", "roc_auc")) %>%                                  
  # Start plotting phase
  ggplot(aes(set, estimate, fill = model)) + 
    # Plot the bars side by side
    geom_col(position = "dodge") +
    # Wrap by metric
    facet_wrap(~ metric) + 
    # Limit the view to 0-1 values
    scale_y_continuous(limits = c(0, 1)) +
    # title
    labs(title = "Precision and ROC AUC on train and test sets in different models") +
    # Minor theme adjustments
    theme(
      plot.title = element_text(hjust = .5),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.x = element_text(angle = 30, vjust = 1)
    )

ggsave(filename = "graphics/ModelFitting01.png", width = 6, height = 4, units = "in", dpi = 300)