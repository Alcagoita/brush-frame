#!/usr/bin/env bash
# Reports which tools the setup needs and whether they are ready. Changes nothing.
# Usage: check-tools.sh
set -u

status=0
check() {
  local name="$1" required="$2" hint="$3"
  if command -v "$name" >/dev/null 2>&1; then
    printf '  ok       %-9s %s\n' "$name" "$("$name" --version 2>/dev/null | head -1)"
  elif [ "$required" = "required" ]; then
    printf '  MISSING  %-9s required. %s\n' "$name" "$hint"
    status=1
  else
    printf '  -        %-9s optional. %s\n' "$name" "$hint"
  fi
}

echo "Tools"
check git      required "https://git-scm.com/downloads"
check gh       required "https://cli.github.com  (macOS: brew install gh)"
check curl     required "Usually preinstalled."
check jq       optional "Only for Jira setup. macOS: brew install jq"
check node     optional "Only for node projects. https://nodejs.org"
check python3  optional "Only for python projects."
check firebase optional "Only for Firebase App Distribution: npm install -g firebase-tools"

echo
echo "Logins"
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  printf '  ok       GitHub    logged in as %s\n' "$(gh api user -q .login 2>/dev/null || echo '?')"
else
  printf '  WAITING  GitHub    run: gh auth login\n'
  status=1
fi
if [ -n "${JIRA_SITE:-}" ] && [ -n "${JIRA_EMAIL:-}" ] && [ -n "${JIRA_API_TOKEN:-}" ]; then
  printf '  ok       Jira      JIRA_SITE, JIRA_EMAIL and JIRA_API_TOKEN are set (values not shown)\n'
else
  printf '  -        Jira      not set. Only needed if you choose Jira.\n'
fi

echo
echo "Folder"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf '  ok       git repo  %s, branch %s\n' "$(git rev-parse --show-toplevel)" "$(git branch --show-current 2>/dev/null || echo '?')"
else
  printf '  -        git repo  not a git repository yet (setup will run git init -b main)\n'
fi

exit $status
