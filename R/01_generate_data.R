factor_scores <- rnorm(
  N,
  mean = 0,
  sd = sqrt(factor_variance)
)

continuous_data <- sapply(
  items,
  function(item) {
    loading * factor_scores +
      rnorm(
        N,
        mean = 0,
        sd = sqrt(residual_variance)
      )
  }
)

continuous_data <- as.data.frame(
  continuous_data
)

names(continuous_data) <- items

ordinal_data <- as.data.frame(
  lapply(
    continuous_data,
    function(x) {
      cut(
        x,
        breaks = c(
          -Inf,
          thresholds,
          Inf
        ),
        labels = 1:4,
        ordered_result = TRUE
      )
    }
  )
)

write.csv(
  ordinal_data,
  file.path(
    project_path,
    "data",
    "raw",
    "ordinal_data.csv"
  ),
  row.names = FALSE
)