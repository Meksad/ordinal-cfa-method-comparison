tables_dir <- file.path(
  project_path,
  "results",
  "tables"
)

matrix_dir <- file.path(
  project_path,
  "results",
  "matrices"
)

reports_dir <- file.path(
  project_path,
  "results",
  "reports"
)

write.csv(
  polychoric_matrix,
  file.path(
    matrix_dir,
    "polychoric_matrix.csv"
  ),
  row.names = TRUE
)

xlsx_file <- file.path(
  tables_dir,
  "ordinal_cfa_results.xlsx"
)

wb <- createWorkbook()

header_style <- createStyle(
  textDecoration = "bold",
  halign = "center",
  valign = "center",
  border = "Bottom"
)

write_sheet <- function(
    workbook,
    sheet,
    data
) {
  addWorksheet(
    workbook,
    sheet
  )

  writeData(
    workbook,
    sheet,
    data,
    headerStyle = header_style
  )

  setColWidths(
    workbook,
    sheet,
    cols = seq_len(
      ncol(data)
    ),
    widths = "auto"
  )
}

write_sheet(
  wb,
  "Model Fit",
  model_fit
)

write_sheet(
  wb,
  "Fit Comparison",
  fit_comparison
)

write_sheet(
  wb,
  "Factor Loadings",
  factor_loadings
)

write_sheet(
  wb,
  "R Squared",
  r_squared
)

write_sheet(
  wb,
  "Thresholds",
  thresholds_results
)

write_sheet(
  wb,
  "Convergence",
  convergence
)

write_sheet(
  wb,
  "Heywood Check",
  heywood_check
)

saveWorkbook(
  wb,
  xlsx_file,
  overwrite = TRUE
)

make_md_table <- function(
    data
) {
  if (nrow(data) == 0) {
    return(
      "Tidak ada hasil."
    )
  }

  header <- paste(
    names(data),
    collapse = " | "
  )

  separator <- paste(
    rep(
      "---",
      ncol(data)
    ),
    collapse = " | "
  )

  rows <- apply(
    data,
    1,
    function(x) {
      paste(
        x,
        collapse = " | "
      )
    }
  )

  paste(
    c(
      paste0(
        "| ",
        header,
        " |"
      ),
      paste0(
        "| ",
        separator,
        " |"
      ),
      paste0(
        "| ",
        rows,
        " |"
      )
    ),
    collapse = "\n"
  )
}

md_file <- file.path(
  reports_dir,
  "results.md"
)

md_text <- paste0(
  "# Ordinal CFA Method Comparison\n\n",
  "## Model Fit Indices\n\n",
  make_md_table(
    model_fit
  ),
  "\n\n",
  "## Fit Index Comparison\n\n",
  make_md_table(
    fit_comparison
  ),
  "\n\n",
  "## Factor Loadings\n\n",
  make_md_table(
    factor_loadings
  ),
  "\n\n",
  "## R-squared\n\n",
  make_md_table(
    r_squared
  ),
  "\n\n",
  "## Thresholds\n\n",
  make_md_table(
    thresholds_results
  ),
  "\n\n",
  "## Convergence\n\n",
  make_md_table(
    convergence
  ),
  "\n\n",
  "## Heywood Check\n\n",
  make_md_table(
    heywood_check
  ),
  "\n"
)

writeLines(
  md_text,
  md_file
)

capture_section <- function(
    title,
    data
) {
  c(
    "",
    paste0(
      "================ ",
      title,
      " ================"
    ),
    "",
    capture.output(
      print(
        data,
        row.names = FALSE
      )
    )
  )
}

txt_file <- file.path(
  reports_dir,
  "results.txt"
)

txt_lines <- c(
  "ORDINAL CFA METHOD COMPARISON",
  capture_section(
    "MODEL FIT INDICES",
    model_fit
  ),
  capture_section(
    "FIT INDEX COMPARISON",
    fit_comparison
  ),
  capture_section(
    "FACTOR LOADINGS",
    factor_loadings
  ),
  capture_section(
    "R-SQUARED",
    r_squared
  ),
  capture_section(
    "THRESHOLDS",
    thresholds_results
  ),
  capture_section(
    "CONVERGENCE",
    convergence
  ),
  capture_section(
    "HEYWOOD CHECK",
    heywood_check
  )
)

writeLines(
  unlist(txt_lines),
  txt_file
)

docx_file <- file.path(
  reports_dir,
  "ordinal_cfa_method_comparison.docx"
)

doc <- read_docx()

doc <- body_add_par(
  doc,
  "Ordinal CFA Method Comparison",
  style = "heading 1"
)

sections <- list(
  "1. Model Fit Indices" = model_fit,
  "2. Fit Index Comparison" = fit_comparison,
  "3. Factor Loadings" = factor_loadings,
  "4. R-squared" = r_squared,
  "5. Thresholds" = thresholds_results,
  "6. Convergence" = convergence,
  "7. Heywood Check" = heywood_check
)

for (title in names(sections)) {
  doc <- body_add_par(
    doc,
    title,
    style = "heading 2"
  )

  doc <- body_add_table(
    doc,
    value = sections[[title]]
  )
}

print(
  doc,
  target = docx_file
)