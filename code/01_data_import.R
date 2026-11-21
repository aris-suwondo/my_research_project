# ==============================================================================
# Script: 01_data_import.R
# Project: Palmer Penguins Regression Analysis
#
# Purpose:
#   Load and validate the Palmer Penguins dataset before data processing.
#
# Input:
#   The penguins dataset from the palmerpenguins R package.
#
# Output:
#   data/raw/penguins_raw.csv
#
# How to run:
#   Open a terminal in the project root directory and run:
#   Rscript code/01_data_import.R
#
# Notes for reuse:
#   - Replace the data source if using another dataset.
#   - Update required_columns to match the variables needed in your analysis.
#   - Do not remove missing values in this script.
#   - Data cleaning will be performed in 02_preprocessing.R.
# ==============================================================================


# 1. CHECK REQUIRED PACKAGE ----

# Stop the script if the package is not installed.
# This helps users understand what they need to install.
if (!requireNamespace("palmerpenguins", quietly = TRUE)) {
  stop("Package 'palmerpenguins' is missing. Please install it first.")
}


# 2. LOAD DATA ----

# Load the original dataset from the palmerpenguins package.
# We keep the original observations, including missing values.
data("penguins", package = "palmerpenguins")


# 3. VALIDATE DATA ----

# Check that the dataset contains observations.
# Stop the script if the dataset is empty.
stopifnot(nrow(penguins) > 0)

# Define the columns required for our analysis.
# Update this list when reusing the script with another dataset.
required_columns <- c(
  "species",
  "bill_length_mm",
  "body_mass_g"
)

# Check whether all required columns exist.
# Stop the script if one or more columns are missing.
stopifnot(all(required_columns %in% names(penguins)))


# 4. SAVE IMPORTED DATA ----

# Create the output directory if it does not exist.
# The path is relative to the project root directory.
dir.create(
  "data/raw",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save the imported dataset without removing any observations.
# The output will be used by 02_preprocessing.R.
write.csv(
  penguins,
  "data/raw/penguins_raw.csv",
  row.names = FALSE
)


# 5. PRINT VALIDATION SUMMARY ----

# Display a summary to help users verify the import.
cat("Data import completed successfully.\n")
cat("Number of observations:", nrow(penguins), "\n")
cat("Number of variables:", ncol(penguins), "\n")
cat("Output: data/raw/penguins_raw.csv\n")