#!/usr/bin/env bash
# After `gh auth login`: make Git ready to commit and push on this computer.
#  - your name and email on commits, from your GitHub account, if Git doesn't have them yet
#    (the email is GitHub's private no-reply address, so your real one isn't published);
#  - Git allowed to push to GitHub with the same login (gh auth setup-git).
# Usage: git-identity.sh [--dry-run]
set -u
source "$(dirname "$0")/lib.sh"

for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=1 ;;
    *) fail "Unknown option: $a" ;;
  esac
done

need git
need gh
gh auth status >/dev/null 2>&1 || fail "GitHub isn't logged in yet. Run: gh auth login --web --git-protocol https --scopes project"

say "Getting Git ready to commit and push"

LOGIN="$(gh api user -q .login)" || fail "Couldn't read your GitHub account."
ID="$(gh api user -q .id)"
NAME="$(gh api user -q '.name // empty')"
[ -n "$NAME" ] || NAME="$LOGIN"
EMAIL="${ID}+${LOGIN}@users.noreply.github.com"

if [ -n "$(git config --global user.name 2>/dev/null)" ]; then
  skip "commit name already set ($(git config --global user.name))"
else
  run "set your commit name to \"$NAME\"" -- git config --global user.name "$NAME" && [ "$DRY_RUN" = "1" ] || ok "commit name: $NAME"
fi

if [ -n "$(git config --global user.email 2>/dev/null)" ]; then
  skip "commit email already set ($(git config --global user.email))"
else
  run "set your commit email to GitHub's private address $EMAIL" -- git config --global user.email "$EMAIL" && [ "$DRY_RUN" = "1" ] || ok "commit email: $EMAIL (GitHub's private address)"
fi

run "let Git push to GitHub with your gh login" -- gh auth setup-git && [ "$DRY_RUN" = "1" ] || ok "Git pushes to GitHub with your login"
