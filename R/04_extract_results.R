round_df <- function(
    x,
    digits = 4
) {
  x[] <- lapply(
    x,
    function(z) {
      if (is.numeric(z)) {
        round(
          z,
          digits
        )
      } else {
        z
      }
    }
  )

  x
}

wlsmv_fit <- fitMeasures(
  fit_wlsmv,
  c(
    "chisq.scaled",
    "df.scaled",
    "pvalue.scaled",
    "cfi.scaled",
    "tli.scaled",
    "rmsea.scaled",
    "srmr"
  )
)

poly_fit <- fitMeasures(
  fit_poly,
  c(
    "chisq",
    "df",
    "pvalue",
    "cfi",
    "tli",
    "rmsea",
    "srmr"
  )
)

model_fit <- data.frame(
  Method = c(
    "WLSMV",
    "Polychoric CFA"
  ),
  Chi_Square = c(
    unname(
      wlsmv_fit["chisq.scaled"]
    ),
    unname(
      poly_fit["chisq"]
    )
  ),
  df = c(
    unname(
      wlsmv_fit["df.scaled"]
    ),
    unname(
      poly_fit["df"]
    )
  ),
  p_value = c(
    unname(
      wlsmv_fit["pvalue.scaled"]
    ),
    unname(
      poly_fit["pvalue"]
    )
  ),
  CFI = c(
    unname(
      wlsmv_fit["cfi.scaled"]
    ),
    unname(
      poly_fit["cfi"]
    )
  ),
  TLI = c(
    unname(
      wlsmv_fit["tli.scaled"]
    ),
    unname(
      poly_fit["tli"]
    )
  ),
  RMSEA = c(
    unname(
      wlsmv_fit["rmsea.scaled"]
    ),
    unname(
      poly_fit["rmsea"]
    )
  ),
  SRMR = c(
    unname(
      wlsmv_fit["srmr"]
    ),
    unname(
      poly_fit["srmr"]
    )
  )
)

model_fit <- round_df(
  model_fit
)

wls <- model_fit[
  model_fit$Method == "WLSMV",
  ,
  drop = FALSE
]

poly <- model_fit[
  model_fit$Method == "Polychoric CFA",
  ,
  drop = FALSE
]

fit_comparison <- data.frame(
  Index = c(
    "CFI",
    "TLI",
    "RMSEA",
    "SRMR"
  ),
  WLSMV = c(
    wls$CFI,
    wls$TLI,
    wls$RMSEA,
    wls$SRMR
  ),
  Polychoric_CFA = c(
    poly$CFI,
    poly$TLI,
    poly$RMSEA,
    poly$SRMR
  ),
  Difference_WLSMV_minus_Polychoric = c(
    wls$CFI - poly$CFI,
    wls$TLI - poly$TLI,
    wls$RMSEA - poly$RMSEA,
    wls$SRMR - poly$SRMR
  )
)

fit_comparison <- round_df(
  fit_comparison
)

extract_loadings <- function(
    fit,
    method
) {
  pe <- parameterEstimates(
    fit,
    standardized = TRUE
  )

  out <- pe[
    pe$op == "=~",
    c(
      "lhs",
      "rhs",
      "est",
      "se",
      "std.lv",
      "std.all",
      "pvalue"
    )
  ]

  names(out) <- c(
    "Factor",
    "Item",
    "Estimate",
    "SE",
    "Std_lv",
    "Std_all",
    "p_value"
  )

  out$Method <- method

  out <- out[
    c(
      "Method",
      "Factor",
      "Item",
      "Estimate",
      "SE",
      "Std_lv",
      "Std_all",
      "p_value"
    )
  ]

  round_df(
    out
  )
}

factor_loadings <- rbind(
  extract_loadings(
    fit_wlsmv,
    "WLSMV"
  ),
  extract_loadings(
    fit_poly,
    "Polychoric CFA"
  )
)

extract_r2 <- function(
    fit,
    method
) {
  values <- inspect(
    fit,
    "r2"
  )

  data.frame(
    Method = method,
    Item = names(values),
    R2 = as.numeric(values)
  )
}

r_squared <- rbind(
  extract_r2(
    fit_wlsmv,
    "WLSMV"
  ),
  extract_r2(
    fit_poly,
    "Polychoric CFA"
  )
)

r_squared <- round_df(
  r_squared
)

pe_wlsmv <- parameterEstimates(
  fit_wlsmv
)

thresholds_results <- pe_wlsmv[
  pe_wlsmv$op == "|",
  c(
    "lhs",
    "rhs",
    "est",
    "se",
    "pvalue"
  )
]

names(thresholds_results) <- c(
  "Item",
  "Threshold",
  "Estimate",
  "SE",
  "p_value"
)

thresholds_results <- round_df(
  thresholds_results
)

convergence <- data.frame(
  Method = c(
    "WLSMV",
    "Polychoric CFA"
  ),
  Converged = c(
    lavInspect(
      fit_wlsmv,
      "converged"
    ),
    lavInspect(
      fit_poly,
      "converged"
    )
  )
)

check_heywood <- function(
    fit,
    method
) {
  pe <- parameterEstimates(
    fit,
    standardized = TRUE
  )

  loading_problem <- any(
    pe$op == "=~" &
      (
        pe$std.all < 0 |
        pe$std.all > 1
      ),
    na.rm = TRUE
  )

  r2 <- inspect(
    fit,
    "r2"
  )

  r2_problem <- any(
    r2 < 0 |
      r2 > 1,
    na.rm = TRUE
  )

  residuals <- pe[
    pe$op == "~~" &
      pe$lhs == pe$rhs,
    "est"
  ]

  residual_problem <- any(
    residuals < 0,
    na.rm = TRUE
  )

  data.frame(
    Method = method,
    Loading_Problem = loading_problem,
    R2_Problem = r2_problem,
    Negative_Residual = residual_problem
  )
}

heywood_check <- rbind(
  check_heywood(
    fit_wlsmv,
    "WLSMV"
  ),
  check_heywood(
    fit_poly,
    "Polychoric CFA"
  )
)