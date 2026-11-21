# ==============================================================================
# Script: 03_statistical_analysis.R
# Project: Palmer Penguins Regression Analysis
#
# Purpose:
#   Perform linear regression using the cleaned Palmer Penguins dataset.
#
# Input:
#   data/processed/cleaned_penguins_modular.csv
#
# Output:
#   outputs/reports/regression_results_modular.txt
#
# How to run:
#   Run this command from the project root directory:
#   Rscript code/03_statistical_analysis.R
#
# Notes for reuse:
#   - Change the input path when using another dataset.
#   - Update the regression formula to match your research question.
#   - Check the variables and missing values before running the model.
#   - This script performs statistical analysis only.
#   - Visualization will be performed in 04_visualization.R.
# ==============================================================================


# 1. DEFINE INPUT AND OUTPUT ----

# Define the input and output file paths.
input_file <- "data/processed/cleaned_penguins_modular.csv"

output_file <- "outputs/reports/regression_results_modular.txt"


# 2. CHECK INPUT FILE ----

# Stop if the cleaned dataset does not exist.
# Run 02_preprocessing.R first if this happens.
if (!file.exists(input_file)) {
  stop("Input file not found. Please run 02_preprocessing.R first.")
}


# 3. LOAD CLEANED DATA ----

# Read the dataset produced by the preprocessing script.
processed_data <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)


# 4. VALIDATE DATA ----

# Define the variables required for the regression.
required_columns <- c(
  "bill_length_mm",
  "body_mass_g"
)

# Check whether the required columns are available.
missing_columns <- setdiff(required_columns, names(processed_data))

if (length(missing_columns) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

# Check that both regression variables are numeric.
if (!all(vapply(processed_data[required_columns], is.numeric, logical(1)))) {
  stop("Regression variables must be numeric.")
}

# Stop if the dataset has fewer than three observations.
if (nrow(processed_data) < 3) {
  stop("Not enough observations for regression analysis.")
}

# Stop if the regression variables contain missing or non-finite values.
if (!all(is.finite(as.matrix(processed_data[required_columns])))) {
  stop("Regression variables contain missing or non-finite values.")
}


# 5. PERFORM LINEAR REGRESSION ----

# Model body mass as a function of bill length.
# This follows the same method as the original sample script.
penguin_model <- lm(
  body_mass_g ~ bill_length_mm,
  data = processed_data
)


# 6. SAVE REGRESSION RESULTS ----

# Create the reports directory if needed.
dir.create(
  "outputs/reports",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save the statistical summary to a text file.
# We use the same method as the original script.
sink(output_file)

print(summary(penguin_model))

sink()


# 7. PRINT ANALYSIS SUMMARY ----

# Display basic information in the terminal.
cat("Statistical analysis completed successfully.\n")
cat("Number of observations:", nobs(penguin_model), "\n")
cat("R-squared:", summary(penguin_model)$r.squared, "\n")
cat("Output:", output_file, "\n")