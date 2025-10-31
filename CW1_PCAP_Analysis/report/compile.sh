#!/bin/bash

# COMP3010 CW1 LaTeX Report Compilation Script
# This script compiles the LaTeX report to PDF

echo "======================================"
echo "COMP3010 CW1 Report Compilation"
echo "======================================"
echo ""

# Change to report directory
cd "$(dirname "$0")"

# Check if LaTeX is installed
if ! command -v pdflatex &> /dev/null; then
    echo "❌ Error: pdflatex not found!"
    echo ""
    echo "Please install LaTeX:"
    echo "  macOS: brew install --cask mactex"
    echo "  Or use Overleaf: https://www.overleaf.com"
    echo ""
    exit 1
fi

echo "✅ Found pdflatex"
echo ""

# Check if .tex file exists
if [ ! -f "CW1_Report.tex" ]; then
    echo "❌ Error: CW1_Report.tex not found!"
    exit 1
fi

echo "📄 Compiling CW1_Report.tex..."
echo ""

# First compilation
echo "▶ First pass..."
pdflatex -interaction=nonstopmode CW1_Report.tex > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    echo "Running again with error output..."
    pdflatex CW1_Report.tex
    exit 1
fi

# Second compilation (for references and TOC)
echo "▶ Second pass (for references)..."
pdflatex -interaction=nonstopmode CW1_Report.tex > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Second compilation failed!"
    pdflatex CW1_Report.tex
    exit 1
fi

# Clean up auxiliary files
echo "▶ Cleaning up auxiliary files..."
rm -f *.aux *.log *.out *.toc *.fdb_latexmk *.fls *.synctex.gz

echo ""
echo "✅ Compilation successful!"
echo ""

# Check if PDF was created
if [ -f "CW1_Report.pdf" ]; then
    # Get file size
    size=$(du -h CW1_Report.pdf | cut -f1)
    pages=$(pdfinfo CW1_Report.pdf 2>/dev/null | grep Pages | awk '{print $2}')
    
    echo "📊 Report Details:"
    echo "   File: CW1_Report.pdf"
    echo "   Size: $size"
    
    if [ ! -z "$pages" ]; then
        echo "   Pages: $pages"
        
        if [ "$pages" -gt 10 ]; then
            echo ""
            echo "⚠️  WARNING: Report has $pages pages (limit is 10)"
            echo "   Consider reducing screenshot sizes or margins"
        fi
    fi
    
    echo ""
    echo "✅ Ready to submit!"
    echo ""
    
    # Ask to open PDF
    read -p "Open PDF now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open CW1_Report.pdf
    fi
else
    echo "❌ Error: PDF not created!"
    exit 1
fi

