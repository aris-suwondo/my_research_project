# ==============================================================================
# Script: 04_visualization.R
# Project: Palmer Penguins Regression Analysis
#
# Purpose:
#   Create a regression plot of penguin bill length and body mass.
#
# Input:
#   data/processed/cleaned_penguins_modular.csv
#
# Output:
#   outputs/figures/fig-01-penguin-regression-modular.png
#   outputs/figures/fig-01-penguin-regression-modular.pdf
#
# How to run:
#   Run this command from the project root directory:
#   Rscript code/04_visualization.R
#
# Notes for reuse:
#   - Change the input path when using another dataset.
#   - Update the variables and labels for your research question.
#   - Adjust colors, plot size, and resolution when needed.
#   - Keep the original data unchanged.
# ==============================================================================


# 1. CHECK REQUIRED PACKAGE ----

# Stop if ggplot2 is not installed.
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Package 'ggplot2' is missing. Please install it first.")
}

library(ggplot2)


# 2. DEFINE INPUT AND OUTPUT ----

# Define paths relative to the project root directory.
input_file <- "data/processed/cleaned_penguins_modular.csv"

output_png <- "outputs/figures/fig-01-penguin-regression-modular.png"

output_pdf <- "outputs/figures/fig-01-penguin-regression-modular.pdf"


# 3. LOAD DATA ----

# Check that the cleaned dataset exists.
if (!file.exists(input_file)) {
  stop("Input file not found. Please run 02_preprocessing.R first.")
}

# Read the dataset created by the preprocessing script.
plot_data <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)


# 4. VALIDATE DATA ----

# Define variables needed for visualization.
required_columns <- c(
  "species",
  "bill_length_mm",
  "body_mass_g"
)

# Check whether all required columns exist.
missing_columns <- setdiff(required_columns, names(plot_data))

if (length(missing_columns) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}

# Stop if the dataset is empty.
if (nrow(plot_data) == 0) {
  stop("The dataset is empty.")
}

# Check that the plotting variables are numeric.
numeric_columns <- c("bill_length_mm", "body_mass_g")

if (!all(vapply(plot_data[numeric_columns], is.numeric, logical(1)))) {
  stop("Bill length and body mass must be numeric.")
}

# Check for missing or non-finite values.
if (!all(is.finite(as.matrix(plot_data[numeric_columns])))) {
  stop("Plotting variables contain missing or non-finite values.")
}

if (anyNA(plot_data$species)) {
  stop("Species contains missing values.")
}


# 5. CREATE REGRESSION PLOT ----

# This plot follows the original sample script.
# Each point represents one penguin.
# Species are shown using different colors and shapes.
# The black line represents the fitted linear regression.

reg_plot <- ggplot(
  plot_data,
  aes(x = bill_length_mm, y = body_mass_g)
) +
  geom_point(
    aes(color = species, shape = species),
    alpha = 0.7,
    size = 3
  ) +
  geom_smooth(
    method = "lm",
    color = "black",
    se = TRUE
  ) +
  scale_color_manual(
    values = c("darkorange", "purple", "cyan4")
  ) +
  labs(
    title = "Penguin Size Analysis: Bill Length vs. Body Mass",
    subtitle = "Linear regression across all species",
    x = "Bill Length (mm)",
    y = "Body Mass (g)",
    color = "Species",
    shape = "Species",
    caption = "Source: palmerpenguins R package"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")


# 6. SAVE FIGURES ----

# Create the output directory if needed.
dir.create(
  "outputs/figures",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save PNG for presentations and online use.
ggsave(
  output_png,
  plot = reg_plot,
  width = 10,
  height = 7,
  dpi = 300
)

# Save PDF for documents and publications.
ggsave(
  output_pdf,
  plot = reg_plot,
  width = 10,
  height = 7
)


# 7. PRINT SUMMARY ----

cat("Visualization completed successfully.\n")
cat("Number of observations:", nrow(plot_data), "\n")
cat("PNG:", output_png, "\n")
cat("PDF:", output_pdf, "\n")