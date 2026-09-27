figures_dir <- file.path(
  project_path,
  "results",
  "figures"
)

loading_data <- factor_loadings %>%
  select(
    Method,
    Item,
    Std_all
  )

p1 <- ggplot(
  loading_data,
  aes(
    x = Item,
    y = Std_all,
    group = Method,
    linetype = Method,
    shape = Method
  )
) +
  geom_line(
    linewidth = 1
  ) +
  geom_point(
    size = 3
  ) +
  labs(
    x = "Item",
    y = "Standardized Factor Loading"
  ) +
  theme_minimal()

ggsave(
  file.path(
    figures_dir,
    "factor_loadings_comparison.png"
  ),
  p1,
  width = 8,
  height = 5,
  dpi = 300
)

fit_cfi_tli <- fit_comparison %>%
  filter(
    Index %in% c(
      "CFI",
      "TLI"
    )
  ) %>%
  pivot_longer(
    cols = c(
      WLSMV,
      Polychoric_CFA
    ),
    names_to = "Method",
    values_to = "Value"
  )

p2 <- ggplot(
  fit_cfi_tli,
  aes(
    x = Index,
    y = Value,
    group = Method,
    linetype = Method,
    shape = Method
  )
) +
  geom_line(
    linewidth = 1
  ) +
  geom_point(
    size = 3
  ) +
  coord_cartesian(
    ylim = c(
      0,
      1
    )
  ) +
  labs(
    x = "Fit Index",
    y = "Value"
  ) +
  theme_minimal()

ggsave(
  file.path(
    figures_dir,
    "fit_cfi_tli_comparison.png"
  ),
  p2,
  width = 8,
  height = 5,
  dpi = 300
)

fit_rmsea_srmr <- fit_comparison %>%
  filter(
    Index %in% c(
      "RMSEA",
      "SRMR"
    )
  ) %>%
  pivot_longer(
    cols = c(
      WLSMV,
      Polychoric_CFA
    ),
    names_to = "Method",
    values_to = "Value"
  )

p3 <- ggplot(
  fit_rmsea_srmr,
  aes(
    x = Index,
    y = Value,
    group = Method,
    linetype = Method,
    shape = Method
  )
) +
  geom_line(
    linewidth = 1
  ) +
  geom_point(
    size = 3
  ) +
  labs(
    x = "Fit Index",
    y = "Value"
  ) +
  theme_minimal()

ggsave(
  file.path(
    figures_dir,
    "fit_rmsea_srmr_comparison.png"
  ),
  p3,
  width = 8,
  height = 5,
  dpi = 300
)

r2_data <- r_squared %>%
  select(
    Method,
    Item,
    R2
  )

p4 <- ggplot(
  r2_data,
  aes(
    x = Item,
    y = R2,
    group = Method,
    linetype = Method,
    shape = Method
  )
) +
  geom_line(
    linewidth = 1
  ) +
  geom_point(
    size = 3
  ) +
  coord_cartesian(
    ylim = c(
      0,
      1
    )
  ) +
  labs(
    x = "Item",
    y = "R-squared"
  ) +
  theme_minimal()

ggsave(
  file.path(
    figures_dir,
    "r_squared_comparison.png"
  ),
  p4,
  width = 8,
  height = 5,
  dpi = 300
)

polychoric_long <- as.data.frame(
  as.table(
    polychoric_matrix
  )
)

names(polychoric_long) <- c(
  "Item1",
  "Item2",
  "Correlation"
)

p5 <- ggplot(
  polychoric_long,
  aes(
    x = Item2,
    y = Item1,
    fill = Correlation
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = sprintf(
        "%.2f",
        Correlation
      )
    ),
    size = 4
  ) +
  coord_equal() +
  labs(
    x = NULL,
    y = NULL,
    fill = "Correlation"
  ) +
  theme_minimal()

ggsave(
  file.path(
    figures_dir,
    "polychoric_correlation_matrix.png"
  ),
  p5,
  width = 7,
  height = 6,
  dpi = 300
)