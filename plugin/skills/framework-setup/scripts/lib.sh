#!/usr/bin/env bash
# Shared helpers for the framework setup scripts. Source this file; do not run it.
# Works with the bash 3.2 that ships on macOS.

DRY_RUN=0

say()  { printf '%s\n' "$*"; }
ok()   { printf '  ok      %s\n' "$*"; }
skip() { printf '  skip    %s\n' "$*"; }
warn() { printf '  warn    %s\n' "$*" >&2; }
fail() { printf '  error   %s\n' "$*" >&2; exit 1; }
plan() { printf '  plan    %s\n' "$*"; }

# run <description> -- <command...>
# In dry-run mode prints the plan; otherwise runs the command.
run() {
  local desc="$1"; shift
  [ "${1:-}" = "--" ] && shift
  if [ "$DRY_RUN" = "1" ]; then
    plan "$desc"
    return 0
  fi
  "$@"
}

need() {
  command -v "$1" >/dev/null 2>&1 || fail "'$1' is not installed. Install it and run this again."
}

# Directory of the skill (scripts/..)
skill_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}
