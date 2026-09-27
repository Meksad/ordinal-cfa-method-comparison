project_path <- "/cloud/project/ordinal-cfa-method-comparison"

setwd(
  project_path
)

source(
  file.path(
    project_path,
    "R",
    "00_config.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "01_generate_data.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "02_fit_wlsmv.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "03_fit_polychoric.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "04_extract_results.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "05_export_results.R"
  )
)

source(
  file.path(
    project_path,
    "R",
    "06_create_figures.R"
  )
)