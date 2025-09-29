#!/usr/bin/env bash
set -euo pipefail

# ---- defaults ----
CANVAS_W=600
CANVAS_H=800
IMG_EXT=png
IMG_QUALITY=92

# ---- parse args ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --size)
      shift
      if [[ "${1:-}" =~ ^([0-9]+)x([0-9]+)$ ]]; then
        CANVAS_W="${BASH_REMATCH[1]}"
        CANVAS_H="${BASH_REMATCH[2]}"
        shift
      else
        echo "Invalid --size. Use like: --size 600x800"; exit 1
      fi
      ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# ---- deps ----
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
need pdftoppm
if command -v magick >/dev/null 2>&1; then IMGCMD="magick"; else need convert; IMGCMD="convert"; fi
need ebook-convert
need zip

shopt -s nullglob
PDFS=( *.pdf )
[[ ${#PDFS[@]} -gt 0 ]] || { echo "No PDFs found."; exit 0; }

echo "Canvas: ${CANVAS_W}x${CANVAS_H}, grayscale: true, output: AZW3 (via CBZ)."

for pdf in "${PDFS[@]}"; do
  base="${pdf%.pdf}"
  workdir="$(mktemp -d)"
  imgdir="$workdir/img"
  mkdir -p "$imgdir"

  echo "==> Processing: $pdf"

  # 1) Render PDF pages to PNGs
  MAX_SIDE=$(( CANVAS_W > CANVAS_H ? CANVAS_W : CANVAS_H ))
  pdftoppm -png -scale-to "$MAX_SIDE" "$pdf" "$imgdir/page" >/dev/null

  # 2) Pad each image to exactly CANVAS_W x CANVAS_H + force grayscale
  n=1
  for src in "$imgdir"/page-*.png; do
    num=$(printf "%05d" "$n")
    dst="$imgdir/$num.$IMG_EXT"

    if [[ "$IMG_EXT" == "png" ]]; then
      "$IMGCMD" "$src" \
        -resize "${CANVAS_W}x${CANVAS_H}>" \
        -gravity center -background white -extent "${CANVAS_W}x${CANVAS_H}" \
        -colorspace Gray \
        "$dst"
    else
      "$IMGCMD" "$src" \
        -resize "${CANVAS_W}x${CANVAS_H}>" \
        -gravity center -background white -extent "${CANVAS_W}x${CANVAS_H}" \
        -colorspace Gray \
        -quality "$IMG_QUALITY" \
        "$dst"
    fi

    # Page 1 as cover
    if [[ $n -eq 1 ]]; then
      cover_img="$workdir/cover.$IMG_EXT"
      cp "$dst" "$cover_img"
    fi
    n=$((n+1))
  done

  # 3) Create CBZ
  cbz="$workdir/${base}.cbz"
  ( cd "$imgdir" && zip -q -Z store "$cbz" $(ls -1 *.$IMG_EXT | sort) )

  # 4) Convert CBZ -> AZW3 with first page as cover
  out="${base}.azw3"
  ebook-convert "$cbz" "$out" \
    --keep-aspect-ratio \
    --output-profile kindle \
    --cover "$cover_img"

  echo "   -> Wrote: $out"
  rm -rf "$workdir"
done

echo "All done."
