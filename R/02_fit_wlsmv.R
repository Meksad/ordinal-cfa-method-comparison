data_file <- file.path(
  project_path,
  "data",
  "raw",
  "ordinal_data.csv"
)

ordinal_data <- read.csv(
  data_file,
  stringsAsFactors = FALSE
)

ordinal_data[] <- lapply(
  ordinal_data,
  ordered
)

fit_wlsmv <- cfa(
  model = model_cfa,
  data = ordinal_data,
  ordered = names(ordinal_data),
  estimator = "WLSMV"
)