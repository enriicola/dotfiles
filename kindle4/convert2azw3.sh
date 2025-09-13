#!/usr/bin/env bash
set -euo pipefail

# Batch converter: PDFs and EPUBs in current directory -> AZW3
# - PDFs: Each page preserved as fixed-layout (images) with first page as cover
# - EPUBs: Direct conversion to AZW3
# - Output: file.azw3 next to original file
# - Skips conversion if AZW3 already exists

have(){ command -v "$1" >/dev/null 2>&1; }

# Check dependencies
for bin in ebook-convert; do
  have "$bin" || { echo "Missing dependency: $bin" >&2; exit 1; }
done

# Check PDF-specific dependencies only if PDFs exist
if ls *.pdf >/dev/null 2>&1; then
  for bin in pdftoppm zip; do
    have "$bin" || { echo "Missing dependency for PDF conversion: $bin" >&2; exit 1; }
  done
fi

# Function to convert PDF to AZW3
convert_pdf() {
  local pdf="$1"
  local stem="${pdf%.*}"
  local out="$stem.azw3"

  echo "Converting PDF: $pdf → $out"

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  # 2. All pages to PNG
  pdftoppm -png "$pdf" "$tmpdir/page" >/dev/null
  pages=( "$tmpdir"/page-*.png )
  [[ ${#pages[@]} -gt 0 ]] || { echo "No pages generated for $pdf"; return 1; }

  # 1. Cover from first page (use first generated page)
  cover_img="$tmpdir/cover.png"
  if [[ -f "${pages[0]}" ]]; then
    cp "${pages[0]}" "$cover_img"
    echo "Using first page as cover"
    
    # Resize for Kindle 4 (optional, needs ImageMagick)
    if have convert && [[ -f "$cover_img" ]]; then
      convert "$cover_img" -resize "600x800^" -gravity center -extent 600x800 \
        -colorspace Gray "$cover_img" 2>/dev/null || {
        echo "Warning: ImageMagick resize failed, using original cover"
      }
    fi
  else
    echo "Warning: Could not generate cover for $pdf"
    cover_img=""
  fi

  # 3. Make CBZ
  cbz="$tmpdir/$stem.cbz"
  (cd "$tmpdir" && zip -q -9 "$cbz" page-*.png)

  # 4. Convert CBZ -> AZW3
  if [[ -n "$cover_img" && -f "$cover_img" ]]; then
    # Convert with cover
    ebook-convert "$cbz" "$out" \
      --output-profile=kindle \
      --cover "$cover_img" >/dev/null 2>&1 || \
    ebook-convert "$cbz" "$out" \
      --output-profile=kindle >/dev/null 2>&1
  else
    # Convert without cover
    ebook-convert "$cbz" "$out" \
      --output-profile=kindle >/dev/null 2>&1
  fi

  echo "✓ Done: $out"
  rm -rf "$tmpdir"
}

# Function to convert EPUB to AZW3
convert_epub() {
  local epub="$1"
  local stem="${epub%.*}"
  local out="$stem.azw3"

  echo "Converting EPUB: $epub → $out"
  
  # Direct conversion from EPUB to AZW3
  ebook-convert "$epub" "$out" \
    --output-profile=kindle >/dev/null 2>&1

  echo "✓ Done: $out"
}

# Process all PDF files
for pdf in *.pdf; do
  [[ -f "$pdf" ]] || continue
  stem="${pdf%.*}"
  out="$stem.azw3"
  
  # Skip if AZW3 already exists
  if [[ -f "$out" ]]; then
    echo "⏭ Skipping $pdf (AZW3 already exists)"
    continue
  fi
  
  convert_pdf "$pdf"
done

# Process all EPUB files
for epub in *.epub; do
  [[ -f "$epub" ]] || continue
  stem="${epub%.*}"
  out="$stem.azw3"
  
  # Skip if AZW3 already exists
  if [[ -f "$out" ]]; then
    echo "⏭ Skipping $epub (AZW3 already exists)"
    continue
  fi
  
  convert_epub "$epub"
done

echo "Conversion completed!"
