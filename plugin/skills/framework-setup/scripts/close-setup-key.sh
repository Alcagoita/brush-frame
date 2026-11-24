#!/usr/bin/env bash
# Ends the setup's own ticket key (KEY-0 / #0): after this, the commit hook and the
# ticket-key check accept only real tasks (KEY-1 and up). Run it in the setup's last PR.
# Usage: close-setup-key.sh [--dry-run]
set -euo pipefail
. "$(dirname "$0")/lib.sh"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "Not a git repository."
FILE="$(git rev-parse --show-toplevel)/.github/ticket-key-pattern"
[ -f "$FILE" ] || fail ".github/ticket-key-pattern not found. Run install-files.sh first."

OLD="$(head -1 "$FILE")"
case "$OLD" in
  *'[1-9][0-9]*'*) skip "the setup key is already closed ($OLD)"; exit 0 ;;
  *'[0-9]+'*) ;;
  *) fail "unexpected pattern, left as it is: $OLD" ;;
esac
NEW="$(printf '%s' "$OLD" | sed 's/\[0-9\]+/[1-9][0-9]*/')"

if [ "$DRY_RUN" = "1" ]; then
  plan "change .github/ticket-key-pattern: $OLD -> $NEW"
else
  printf '%s\n' "$NEW" > "$FILE"
  ok "closed the setup key: $NEW"
fi
say "From the next pull request on, -0 is refused: every change needs its own task."
