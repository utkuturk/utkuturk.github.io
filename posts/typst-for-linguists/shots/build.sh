#!/bin/sh
# Re-render every output figure in the post. Run from this directory.
# Each out-*.typ is the exact snippet shown in index.qmd, compiled on its own
# page so the SVG crops to the content.
set -e
for f in out-*.typ; do
  typst compile "$f" "${f%.typ}.svg"
  echo "built ${f%.typ}.svg"
done
