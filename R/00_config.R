project_path <- "/cloud/project/ordinal-cfa-method-comparison"

packages <- c(
  "lavaan",
  "openxlsx",
  "officer",
  "ggplot2",
  "tidyr",
  "dplyr"
)

installed <- rownames(installed.packages())

missing <- setdiff(
  packages,
  installed
)

if (length(missing) > 0) {
  install.packages(
    missing,
    repos = "https://cloud.r-project.org"
  )
}

invisible(
  lapply(
    packages,
    library,
    character.only = TRUE
  )
)

set.seed(20260927)

N <- 1000

loading <- 0.70

factor_variance <- 1

residual_variance <- 1 - loading^2

thresholds <- qnorm(
  c(
    0.25,
    0.50,
    0.75
  )
)

items <- paste0(
  "Y",
  1:5
)

model_cfa <- '
F =~ Y1 + Y2 + Y3 + Y4 + Y5
'

dir.create(
  file.path(
    project_path,
    "data",
    "raw"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(
    project_path,
    "data",
    "processed"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(
    project_path,
    "results",
    "tables"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(
    project_path,
    "results",
    "figures"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(
    project_path,
    "results",
    "matrices"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  file.path(
    project_path,
    "results",
    "reports"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)