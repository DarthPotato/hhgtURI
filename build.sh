#!/usr/bin/env bash
# Rebuild every entry as InDesign-placeable ICML.
# Usage: ./build.sh            rebuild everything
#        ./build.sh entries/buildings   rebuild one section
set -euo pipefail

SRC="${1:-entries}"
OUT="layout/icml"
fail=0
built=0

command -v pandoc >/dev/null || { echo "pandoc not installed"; exit 1; }


while IFS= read -r -d '' md; do
  base="$(basename "$md")"
  [[ "$base" == _* ]] && continue          # _templates and _examples are skipped

  rel="${md#entries/}"
  dest="$OUT/${rel%.md}.icml"
  mkdir -p "$(dirname "$dest")"

  # Gate: an entry marked final must not still have open source tags.
  status="$(awk '/^---[[:space:]]*$/{f++; next} f==1 && /^status:/{print $2; exit}' "$md")"
  if [[ "${status:-}" == "final" ]] && grep -qE '\[NEED SOURCE|\[NEEDS CHECK' "$md"; then
    echo "BLOCKED  $md — marked final but still has open source tags"
    fail=1
    continue
  fi

  # Obsidian image embeds -> standard markdown images:
  #   ![[photo.png|300]]      size hint dropped
  #   ![[photo.png|caption]]  pipe text becomes the caption
  #   ![[photo.png]]          no caption
  sed -E \
    -e 's/!\[\[([^]|]+)\|[0-9]+(x[0-9]+)?\]\]/![](<\1>)/g' \
    -e 's/!\[\[([^]|]+)\|([^]]*)\]\]/![\2](<\1>)/g' \
    -e 's/!\[\[([^]|]+)\]\]/![](<\1>)/g' "$md" |
    pandoc --standalone \
      --from markdown+hard_line_breaks+wikilinks_title_after_pipe \
      --to icml --lua-filter=filters/photo-markers.lua --output "$dest"
  built=$((built+1))
done < <(find "$SRC" -name '*.md' -print0)

echo "built $built file(s) into $OUT/"

# Standing report of every hole in the book.
echo
echo "open source tags:"
grep -rnE '\[NEED SOURCE|\[NEEDS CHECK' entries/ || echo "  none"

# Back up to GitHub. Skip with: NO_PUSH=1 ./build.sh
if [[ "${NO_PUSH:-}" != "1" ]] && git rev-parse --git-dir >/dev/null 2>&1; then
  echo
  git add -A
  git commit -qm "build $(date '+%Y-%m-%d %H:%M')" && echo "committed" || echo "nothing new to commit"
  git push -q && echo "pushed to GitHub" || echo "push failed — check connection or run 'git push' once by hand to log in"
fi

exit $fail
