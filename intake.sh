#!/usr/bin/env bash
# Move phone captures out of your personal vault's inbox into _inbox/ here,
# together with every photo they embed. Run it when you sit down to sort:
#
#   ./intake.sh
#
# Safety rules:
#  - Everything is checked BEFORE anything moves.
#  - A note only moves if every photo it embeds is found exactly once and
#    won't clash with a different file of the same name.
#  - Otherwise the note and its photos stay put and you're told why.
#  - Nothing in _inbox is ever overwritten.
set -euo pipefail

[[ -f intake.conf ]] || { echo "no intake.conf — copy intake.conf.example to intake.conf and fill it in"; exit 1; }
source ./intake.conf

src="$MAIN_VAULT/$INBOX"
dest="_inbox"
[[ -d "$src" ]] || { echo "inbox folder not found: $src"; exit 1; }
mkdir -p "$dest"

declare -A claimed=()   # basename -> source path, for everything planned to move

resolve() {  # sets FOUND (path, or "-" if already in _inbox) or WHY
  local ref="$1" hits=()
  FOUND=""; WHY=""
  if [[ "$ref" == */* ]]; then
    [[ -f "$MAIN_VAULT/$ref" ]] && { FOUND="$MAIN_VAULT/$ref"; return 0; }
  else
    mapfile -d '' hits < <(find "$MAIN_VAULT" -type f -name "$ref" -not -path '*/.obsidian/*' -print0)
    (( ${#hits[@]} == 1 )) && { FOUND="${hits[0]}"; return 0; }
    if (( ${#hits[@]} > 1 )); then
      WHY="${#hits[@]} files named '$ref' in your vault — re-link the right one in Obsidian"
      return 1
    fi
  fi
  [[ -f "$dest/$(basename "$ref")" ]] && { FOUND="-"; return 0; }
  WHY="'$(basename "$ref")' isn't on this computer — over Sync's 5 MB limit? Then it's only on your phone"
  return 1
}

clash() {  # would moving $1 collide with a different file? sets WHY
  local f="$1" name; name="$(basename "$1")"
  if [[ -e "$dest/$name" ]]; then WHY="a different '$name' is already in _inbox — rename one"; return 0; fi
  if [[ -n "${claimed[$name]:-}" && "${claimed[$name]}" != "$f" ]]; then
    WHY="two different files named '$name' in this batch — rename one"; return 0
  fi
  return 1
}

# ---- Pass 1: plan. Nothing moves. ----
plan=(); held=0
mapfile -d '' notes < <(find "$src" -maxdepth 1 -type f -name '*.md' -print0 | sort -z)
for md in "${notes[@]}"; do
  mapfile -t refs < <(grep -oE '!\[\[[^]|]+' "$md" | sed 's/^!\[\[//')
  files=(); problems=()
  for ref in "${refs[@]}"; do
    if resolve "$ref"; then [[ "$FOUND" != "-" ]] && files+=("$FOUND")
    else problems+=("$WHY"); fi
  done
  for f in "${files[@]}" "$md"; do clash "$f" && problems+=("$WHY"); done

  if (( ${#problems[@]} )); then
    echo "  held back: $(basename "$md")"
    printf '      %s\n' "${problems[@]}" | sort -u
    held=$((held+1)); continue
  fi
  for f in "${files[@]}" "$md"; do claimed[$(basename "$f")]="$f"; done
  plan+=("$md")
done

loose=()
mapfile -d '' candidates < <(find "$src" -maxdepth 1 -type f ! -name '*.md' -print0 | sort -z)
for f in "${candidates[@]}"; do
  if clash "$f"; then echo "  held back: $(basename "$f") — $WHY"; held=$((held+1))
  else claimed[$(basename "$f")]="$f"; loose+=("$f"); fi
done

# ---- Pass 2: move exactly what was planned. ----
for name in "${!claimed[@]}"; do
  f="${claimed[$name]}"
  [[ -f "$f" ]] && mv "$f" "$dest/$name"
done

echo "intake: ${#plan[@]} note(s) moved, ${#loose[@]} loose file(s), $held held back"
