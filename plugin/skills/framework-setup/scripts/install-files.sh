#!/usr/bin/env bash
# Writes the framework's guardrail files into the current repository.
# Usage: install-files.sh --stack node|python|other --tickets github|jira|other [--key KEY] --mode solo|team [--dry-run]
#   jira: --key is required (KEY-12).  other (Trello, Linear, Asana, ...): --key KEY when the tool's tasks look
#   like KEY-12 (Linear, YouTrack), none when they're numbered (#12, e.g. Trello card numbers).
#   --key   Jira project key (e.g. APP). Ignored for GitHub Issues.
# Existing files are never overwritten; they are reported as "skip".
set -euo pipefail
. "$(dirname "$0")/lib.sh"

STACK="" TICKETS="" KEY="" MODE="solo"
while [ $# -gt 0 ]; do
  case "$1" in
    --stack) STACK="$2"; shift 2 ;;
    --tickets) TICKETS="$2"; shift 2 ;;
    --key) KEY="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done

case "$STACK" in node|python|other) ;; *) fail "--stack must be node, python or other" ;; esac
case "$TICKETS" in github|jira|other) ;; *) fail "--tickets must be github, jira or other" ;; esac
case "$MODE" in solo|team) ;; *) fail "--mode must be solo or team" ;; esac
if [ "$TICKETS" = "jira" ] || { [ "$TICKETS" = "other" ] && [ -n "$KEY" ]; }; then
  echo "$KEY" | grep -Eq '^[A-Z][A-Z0-9]{1,9}$' || fail "--key must be 2-10 capital letters or digits, starting with a letter (e.g. APP)"
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "Not a git repository. Run: git init -b main"
ROOT="$(git rev-parse --show-toplevel)"
FILES="$(skill_dir)/files"

# Pattern every commit message and PR title must start with.
if [ -n "$KEY" ] && [ "$TICKETS" != "github" ]; then
  PATTERN="^(${KEY}-[0-9]+[: ]|Merge |Revert )"
  EXAMPLE="${KEY}-12: add the invite link"
else
  PATTERN="^(#[0-9]+[: ]|Merge |Revert )"
  EXAMPLE="#12: add the invite link"
fi

# put <source-in-files/> <destination-in-repo>
put() {
  local src="$FILES/$1" dst="$ROOT/$2"
  if [ -e "$dst" ]; then skip "$2 already exists"; return 0; fi
  if [ "$DRY_RUN" = "1" ]; then plan "write $2"; return 0; fi
  mkdir -p "$(dirname "$dst")"
  sed -e "s|__EXAMPLE__|$EXAMPLE|g" -e "s|__KEY__|$KEY|g" "$src" > "$dst"
  ok "wrote $2"
}

say "Installing framework files into $ROOT"

# Ticket-key pattern, read by the hook and the CI check.
if [ -e "$ROOT/.github/ticket-key-pattern" ]; then
  skip ".github/ticket-key-pattern already exists"
elif [ "$DRY_RUN" = "1" ]; then
  plan "write .github/ticket-key-pattern ($PATTERN)"
else
  mkdir -p "$ROOT/.github"; printf '%s\n' "$PATTERN" > "$ROOT/.github/ticket-key-pattern"; ok "wrote .github/ticket-key-pattern"
fi

put "ci/$STACK.yml"              ".github/workflows/ci.yml"
put "ci/ticket-key.yml"          ".github/workflows/ticket-key.yml"
put "pull_request_template.md"   ".github/pull_request_template.md"
put "coderabbit.yaml"            ".coderabbit.yaml"
put "commit-msg"                 ".githooks/commit-msg"

if [ "$TICKETS" = "github" ]; then
  put "issue-templates/decision.md" ".github/ISSUE_TEMPLATE/decision.md"
  put "issue-templates/work.md"     ".github/ISSUE_TEMPLATE/work.md"
  put "issue-templates/feedback.md" ".github/ISSUE_TEMPLATE/feedback.md"
else
  put "issue-templates/decision.md" "docs/templates/decision-ticket.md"
  put "issue-templates/work.md"     "docs/templates/work-ticket.md"
  put "issue-templates/feedback.md" "docs/templates/feedback-ticket.md"
fi

# Hook on, executable.
if [ "$DRY_RUN" = "1" ]; then
  plan "chmod +x .githooks/commit-msg and git config core.hooksPath .githooks"
else
  chmod +x "$ROOT/.githooks/commit-msg"
  git -C "$ROOT" config core.hooksPath .githooks
  ok "commit-msg hook on (core.hooksPath = .githooks)"
fi

# Secrets block in .gitignore, once.
MARK="# framework: secrets"
if [ -f "$ROOT/.gitignore" ] && grep -qF "$MARK" "$ROOT/.gitignore"; then
  skip ".gitignore already has the secrets block"
elif [ "$DRY_RUN" = "1" ]; then
  plan "append the secrets block to .gitignore"
else
  { [ -s "$ROOT/.gitignore" ] && echo; cat "$FILES/gitignore-secrets"; } >> "$ROOT/.gitignore"
  ok "added the secrets block to .gitignore"
fi

say ""
say "Commit format: every commit and PR title starts like \"$EXAMPLE\"."
say "Note: the commit-msg hook is turned on per clone. After cloning, run: git config core.hooksPath .githooks"
