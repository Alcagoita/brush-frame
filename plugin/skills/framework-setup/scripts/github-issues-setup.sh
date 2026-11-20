#!/usr/bin/env bash
# Sets up GitHub Issues as the ticket system: labels and the practice issue.
# Usage: github-issues-setup.sh --repo owner/name [--dry-run]
set -euo pipefail
. "$(dirname "$0")/lib.sh"

REPO=""
while [ $# -gt 0 ]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done
[ -n "$REPO" ] || fail "--repo owner/name is required"
need gh

say "Ticket system: GitHub Issues on $REPO"

label() {
  if [ "$DRY_RUN" = "1" ]; then plan "label $1"; return 0; fi
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null && ok "label $1"
}
label decision "c1802e" "Idea check (step 1) — holds the decider's OK"
label work     "5b7fd4" "One goal, small enough for one branch (step 3)"
label feedback "5ba87a" "From testers or real use (step 6)"
label bug      "c2553f" "Something broken"
label wont-do  "8b857a" "Closed with a reason, not built"

TITLE="Practice: run the build loop once"
if [ "$DRY_RUN" = "1" ]; then
  plan "open issue \"$TITLE\""
elif gh issue list --repo "$REPO" --search "\"$TITLE\" in:title" --state all --json number -q '.[0].number' | grep -q .; then
  skip "practice issue already exists"
else
  URL="$(gh issue create --repo "$REPO" --title "$TITLE" --label work --body "$(cat <<'EOF'
## Goal
Run one change through the whole build loop, so the setup is proven.

## Done when
- [ ] A branch named after this issue (e.g. `1-practice`)
- [ ] One small change, committed with this issue's number first (e.g. `#1: practice change`)
- [ ] A PR into `develop`, with the `test` and `ticket-key` checks green
- [ ] Merged on the decider's word

## Out of scope
Anything else.
EOF
)")"
  ok "practice issue: $URL"
fi
