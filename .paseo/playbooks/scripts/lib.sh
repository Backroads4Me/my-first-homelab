# Shared helpers for the guide playbook's script steps. Sourced by them, not run directly.

# Prints a step result as the one-line JSON object the playbooks plugin reads from the last
# stdout line: emit_result <outcome or ""> <summary> [outputs JSON object]
emit_result() {
  RESULT_OUTCOME="$1" RESULT_SUMMARY="$2" RESULT_OUTPUTS="${3:-}" node -e '
    const r = { summary: process.env.RESULT_SUMMARY };
    if (process.env.RESULT_OUTCOME) r.outcome = process.env.RESULT_OUTCOME;
    if (process.env.RESULT_OUTPUTS) r.outputs = JSON.parse(process.env.RESULT_OUTPUTS);
    console.log(JSON.stringify(r));'
}

# Parses PLAYBOOK_INPUT_CHANGED_FILES (paths separated by newlines, commas or spaces) into the
# CHANGED_PATHS array. Each path must be repo-relative, under src/ or public/, or be
# astro.config.mjs, and must exist or be a tracked file (a deletion). On a bad list, sets ERR
# and returns 1. Call it in the main shell, not in $( ), so CHANGED_PATHS and ERR survive.
collect_changed_paths() {
  CHANGED_PATHS=()
  ERR=""
  local raw path
  raw="$(printf '%s' "${PLAYBOOK_INPUT_CHANGED_FILES:-}" | tr ',[:space:]' '\n')"
  while IFS= read -r path; do
    path="${path#./}"
    [[ -z "$path" ]] && continue
    if [[ "$path" == /* || "/$path/" == */../* ]]; then
      ERR="changed_files: \"$path\" must be a repo-relative path without .."
      return 1
    fi
    if [[ ! "$path" =~ ^(src/|public/) && "$path" != "astro.config.mjs" ]]; then
      ERR="changed_files: \"$path\" is outside src/, public/ and astro.config.mjs"
      return 1
    fi
    if [[ ! -e "$path" ]] && ! git ls-files --error-unmatch -- "$path" >/dev/null 2>&1; then
      ERR="changed_files: \"$path\" does not exist and is not a tracked file"
      return 1
    fi
    CHANGED_PATHS+=("$path")
  done <<< "$raw"
  if (( ${#CHANGED_PATHS[@]} == 0 )); then
    ERR="changed_files is empty: list every file the draft created, changed or deleted"
    return 1
  fi
}
