#!/usr/bin/env bash
# Deterministic check of a guide draft: the target file and changed-file list are valid, and the
# site builds. A draft problem exits 1 with a JSON summary (the playbook loops back to draft);
# a broken environment exits 0 with outcome env_error (the playbook fails the run instead).
set -uo pipefail

source "$(dirname "$0")/lib.sh"

if [[ ! -x node_modules/.bin/astro ]]; then
  emit_result env_error "node_modules is missing or incomplete in $PWD: run npm ci, then restart the run from verify_build."
  exit 0
fi

target="${PLAYBOOK_INPUT_TARGET_FILE:-}"
if [[ ! "$target" =~ ^src/content/docs/.+\.mdx?$ || "/$target/" == */../* ]]; then
  emit_result "" "target_file \"$target\" must be a .md or .mdx path under src/content/docs/."
  exit 1
fi
if [[ ! -f "$target" ]]; then
  emit_result "" "target_file \"$target\" does not exist: write the guide there."
  exit 1
fi

if ! collect_changed_paths; then
  emit_result "" "$ERR"
  exit 1
fi
listed=0
for path in "${CHANGED_PATHS[@]}"; do
  [[ "$path" == "$target" ]] && listed=1
done
if (( ! listed )); then
  emit_result "" "changed_files does not list target_file \"$target\"."
  exit 1
fi

log="$(mktemp)"
trap 'rm -f "$log"' EXIT
echo "[verify_build] npm run build"
NO_COLOR=1 FORCE_COLOR=0 npm run build >"$log" 2>&1
status=$?
cat "$log"
if (( status != 0 )); then
  tail_lines="$(sed -E 's/\x1b\[[0-9;]*[A-Za-z]//g' "$log" | grep -v '^npm error' | tail -n 40)"
  (( ${#tail_lines} > 3500 )) && tail_lines="${tail_lines: -3500}"
  emit_result "" "Astro build failed (exit $status). Last build output:
${tail_lines}"
  exit 1
fi

emit_result "" "Site built successfully; $target and ${#CHANGED_PATHS[@]} changed file(s) checked."
