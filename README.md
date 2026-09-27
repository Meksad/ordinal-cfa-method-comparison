# Ordinal CFA Method Comparison

## Overview

This project compares two analytical approaches for confirmatory factor analysis (CFA) with ordinal indicators.

The two approaches are:

1. WLSMV CFA using raw ordinal data.
2. CFA based on a polychoric correlation matrix.

Both approaches are applied to the same generated ordinal dataset.

## Population Model

| Parameter | Value |
|---|---:|
| Number of indicators | 5 |
| Factor loading | 0.70 |
| Factor variance | 1.00 |
| Number of categories | 4 |
| Sample size | 500 |
| Random seed | 20260927 |

## Indicators

The model contains five observed indicators:

- Y1
- Y2
- Y3
- Y4
- Y5

## Estimation

### WLSMV

The ordinal indicators are analyzed directly using the WLSMV estimator.

### Polychoric Correlation-Based CFA

A CFA model is estimated using the polychoric correlation matrix.

This condition is treated as a separate analytical approach and should not be interpreted as equivalent to the complete WLSMV procedure.

## Primary Fit Indices

- CFI
- RMSEA

## Secondary Fit Indices

- TLI
- SRMR
- Chi-square
- Degrees of freedom
- p-value

## Project Structure

```text
ordinal-cfa-method-comparison/
├── R/
├── data/
├── results/
├── docs/
├── README.md
├── LICENSE
├── .gitignore
└── run_analysis.R
```

## Outputs

The analysis produces:

- Excel workbook
- Word report
- Markdown report
- Plain-text report
- Generated ordinal dataset in CSV format
- Polychoric correlation matrix in CSV format

## Reproducibility

The random seed is fixed in the configuration file.

Run `run_analysis.R` to reproduce the complete analysis.
