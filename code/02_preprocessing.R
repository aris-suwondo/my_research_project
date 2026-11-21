# ==============================================================================
# Script: 02_preprocessing.R
# Project: Palmer Penguins Regression Analysis
#
# Purpose:
#   Clean the imported dataset before statistical analysis.
#
# Input:
#   data/raw/penguins_raw.csv
#
# Output:
#   data/processed/cleaned_penguins_modular.csv
#
# How to run:
#   Run this command from the project root directory:
#   Rscript code/02_preprocessing.R
#
# Notes for reuse:
#   - Update the input file path when using another dataset.
#   - Change required_columns based on the variables needed.
#   - Review the missing-value rules before using them for other data.
#   - This script does not perform statistical analysis.
# ==============================================================================


# 1. DEFINE INPUT AND OUTPUT ----

# Define file paths relative to the project root.
input_file <- "data/raw/penguins_raw.csv"

output_file <- "data/processed/cleaned_penguins_modular.csv"


# 2. CHECK INPUT FILE ----

# Stop if the raw dataset does not exist.
# Run 01_data_import.R first if this happens.
if (!file.exists(input_file)) {
  stop("Input file not found. Please run 01_data_import.R first.")
}


# 3. LOAD RAW DATA ----

# Read the imported CSV file.
# Keep text columns as characters.
raw_data <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)


# 4. VALIDATE DATA ----

# Define the variables needed for the regression.
required_columns <- c(
  "bill_length_mm",
  "body_mass_g"
)

# Check whether the required columns exist.
missing_columns <- setdiff(required_columns, names(raw_data))

if (length(missing_columns) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

# Stop if the dataset has no observations.
if (nrow(raw_data) == 0) {
  stop("The input dataset is empty.")
}

# Check that the regression variables are numeric.
if (!all(vapply(raw_data[required_columns], is.numeric, logical(1)))) {
  stop("Regression variables must be numeric.")
}


# 5. REMOVE MISSING VALUES ----

# Remove rows where bill length or body mass is missing.
# This follows the same rule as the original sample script.
#
# Missing values in other columns are kept.
cleaned_data <- raw_data[
  !is.na(raw_data$bill_length_mm) &
    !is.na(raw_data$body_mass_g),
  ,
  drop = FALSE
]

# Stop if no valid observations remain.
if (nrow(cleaned_data) == 0) {
  stop("No valid observations remain after preprocessing.")
}


# 6. SAVE CLEANED DATA ----

# Create the output directory if needed.
dir.create(
  "data/processed",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save the cleaned dataset as CSV.
write.csv(
  cleaned_data,
  output_file,
  row.names = FALSE
)


# 7. PRINT PROCESSING SUMMARY ----

# Count how many observations were removed.
removed_rows <- nrow(raw_data) - nrow(cleaned_data)

cat("Preprocessing completed successfully.\n")
cat("Original observations:", nrow(raw_data), "\n")
cat("Removed observations:", removed_rows, "\n")
cat("Cleaned observations:", nrow(cleaned_data), "\n")
cat("Output:", output_file, "\n")