#!/usr/bin/env bash
# Creates or configures the GitHub repository for the framework: Gitflow branches and merge rules.
# Usage: github-setup.sh --repo owner/name --visibility public|private --mode solo|team [--dry-run]
# Run from inside the local repository, after the setup files are committed on main.
set -euo pipefail
. "$(dirname "$0")/lib.sh"

REPO="" VIS="" MODE="solo"
while [ $# -gt 0 ]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --visibility) VIS="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done
echo "$REPO" | grep -Eq '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$' || fail "--repo must look like owner/name"
case "$VIS" in public|private) ;; *) fail "--visibility must be public or private" ;; esac
case "$MODE" in solo|team) ;; *) fail "--mode must be solo or team" ;; esac

need git; need gh
gh auth status >/dev/null 2>&1 || fail "GitHub CLI is not logged in. Run: gh auth login --web --git-protocol https --scopes project"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "Run this inside the project's git repository."
git rev-parse --verify main >/dev/null 2>&1 || fail "No 'main' branch with a commit yet. Commit the setup files on main first."

FILES="$(skill_dir)/files"
APPROVALS=0; [ "$MODE" = "team" ] && APPROVALS=1

say "GitHub setup for $REPO ($VIS, $MODE)"

# 1. Repository and remote
if gh repo view "$REPO" >/dev/null 2>&1; then
  skip "repository $REPO exists"
  if ! git remote get-url origin >/dev/null 2>&1; then
    run "add remote origin" -- git remote add origin "https://github.com/$REPO.git"
  fi
else
  run "create $VIS repository $REPO and push main" -- gh repo create "$REPO" "--$VIS" --source . --remote origin --push
  [ "$DRY_RUN" = "1" ] || ok "created $REPO"
fi
run "push main" -- git push -u origin main

# 2. develop branch, default branch, merge settings
if git rev-parse --verify develop >/dev/null 2>&1; then
  skip "local develop exists"
else
  run "create develop from main" -- git branch develop main
fi
run "push develop" -- git push -u origin develop
run "make develop the default branch, delete branches after merge" -- \
  gh repo edit "$REPO" --default-branch develop --delete-branch-on-merge --enable-merge-commit
[ "$DRY_RUN" = "1" ] || ok "develop is the default branch"

# 3. Secret scanning and push protection (free on public repositories)
if [ "$DRY_RUN" = "1" ]; then
  plan "turn on secret scanning and push protection"
elif printf '%s' '{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}' \
     | gh api -X PATCH "repos/$REPO" --input - >/dev/null 2>&1; then
  ok "secret scanning and push protection on"
else
  warn "GitHub refused secret scanning for this repository (private repositories need GitHub Advanced Security). Listed in the report."
fi

# 4. Ruleset for main and develop
RULESET_NAME="framework: main and develop"
BODY="$(sed "s/__APPROVALS__/$APPROVALS/" "$FILES/ruleset.json")"
EXISTING=""
if gh repo view "$REPO" >/dev/null 2>&1; then
  EXISTING="$(gh api "repos/$REPO/rulesets" -q ".[] | select(.name==\"$RULESET_NAME\") | .id" 2>/dev/null || true)"
  echo "$EXISTING" | grep -Eq '^[0-9]+$' || EXISTING=""
fi
if [ "$DRY_RUN" = "1" ]; then
  plan "$( [ -n "$EXISTING" ] && echo update || echo add ) ruleset: PR required ($APPROVALS approvals), checks test + ticket-key, no direct push or deletion, admins merge through a PR"
elif [ -n "$EXISTING" ]; then
  if printf '%s' "$BODY" | gh api -X PUT "repos/$REPO/rulesets/$EXISTING" --input - >/dev/null 2>&1; then ok "ruleset updated"; else warn "could not update the ruleset"; fi
else
  if printf '%s' "$BODY" | gh api -X POST "repos/$REPO/rulesets" --input - >/dev/null 2>&1; then
    ok "ruleset added for main and develop"
  else
    warn "GitHub refused the ruleset. On the free plan, rulesets only work on public repositories. Make the repository public or upgrade, then run this again."
  fi
fi

say ""
if [ "$MODE" = "solo" ]; then
  say "Merge on the decider's word: gh pr merge <number> --merge --admin"
else
  say "Merge on the decider's word, after one approval: gh pr merge <number> --merge"
fi
