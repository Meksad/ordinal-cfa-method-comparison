polychoric_matrix <- lavCor(
  ordinal_data,
  ordered = names(ordinal_data)
)

rownames(polychoric_matrix) <- names(
  ordinal_data
)

colnames(polychoric_matrix) <- names(
  ordinal_data
)

fit_poly <- cfa(
  model = model_cfa,
  sample.cov = polychoric_matrix,
  sample.nobs = nrow(ordinal_data),
  estimator = "ML"
)