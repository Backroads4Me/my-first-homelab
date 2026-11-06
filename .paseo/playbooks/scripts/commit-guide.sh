#!/usr/bin/env bash
# Commits the approved guide files to the current branch of the run's checkout. Local only: it
# never pushes. Script steps normally leave the checkout alone because the plugin's concurrency
# rule does not see them; this one runs after the final gate, when no other step of the run is
# active, and commits only the paths the draft listed in changed_files.
set -uo pipefail

source "$(dirname "$0")/lib.sh"

if ! collect_changed_paths; then
  emit_result "" "$ERR"
  exit 1
fi

if ! out="$(git add -A -- "${CHANGED_PATHS[@]}" 2>&1)"; then
  emit_result "" "git add failed: $out"
  exit 1
fi

if git diff --cached --quiet -- "${CHANGED_PATHS[@]}"; then
  head="$(git rev-parse HEAD)"
  emit_result "" "Nothing to commit: the listed files match HEAD $head." "{\"commit\": \"$head\"}"
  exit 0
fi

topic="$(printf '%s' "${PLAYBOOK_INPUT_TOPIC:-guide}" | tr -s '[:space:]' ' ' | cut -c1-60)"
if ! out="$(git commit --only -m "docs: ${topic}" -m "Playbook-Run: ${PLAYBOOK_RUN_ID:-unknown}" -- "${CHANGED_PATHS[@]}" 2>&1)"; then
  emit_result "" "git commit failed: $out"
  exit 1
fi

head="$(git rev-parse HEAD)"
branch="$(git branch --show-current)"
emit_result "" "Committed ${#CHANGED_PATHS[@]} file(s) to ${branch:-detached HEAD} as $head (not pushed)." "{\"commit\": \"$head\"}"
