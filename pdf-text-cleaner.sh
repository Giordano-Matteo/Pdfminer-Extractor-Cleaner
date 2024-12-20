#!/bin/bash

# PDF to Clean Text Processing Script
# Converts PDFs to clean UTF-8 text files, removing BOMs, CRLFs, and end-of-line hyphenation

# Check if poppler-utils is installed (for PDF to text conversion)
if ! command -v pdftotext &> /dev/null; then
    echo "Error: poppler-utils is not installed. Please install it using:"
    echo "brew install poppler"
    exit 1
fi

# Set locale to UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# Input directory of PDFs
input_dir="/Users/Example/..."

# Output directory for cleaned text files
output_dir="${input_dir}/cleaned_texts"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Process each PDF in the input directory
for pdf in "$input_dir"/*.pdf; do
    # Skip if no PDFs found
    [ -e "$pdf" ] || continue

    # Generate output filename
    filename=$(basename "$pdf" .pdf)
    cleaned_txt="${output_dir}/${filename}.txt"

    # Convert PDF to text and immediately process
    pdftotext -layout "$pdf" - | \
    sed -e 's/^\xef\xbb\xbf//' | \
    sed -e 's/\r//g' | \
    tr '\n' '~' | \
    sed 's/-~//g' | \
    tr '~' '\n' > "$cleaned_txt"

    echo "Processed: $pdf -> $cleaned_txt"
done

echo "Conversion complete. Cleaned text files are in $output_dir"
