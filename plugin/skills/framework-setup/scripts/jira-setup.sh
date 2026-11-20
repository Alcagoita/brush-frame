#!/usr/bin/env bash
# Sets up Jira as the ticket system: project (optional), "Won't do" resolution, practice ticket.
# Usage: jira-setup.sh --key KEY --name "Project name" [--create-project] [--dry-run]
# Needs, set by the user in their own terminal (never pasted into a chat):
#   JIRA_SITE=yoursite.atlassian.net  JIRA_EMAIL=you@example.com  JIRA_API_TOKEN=...
# The token is read from the environment and never printed.
set -euo pipefail
. "$(dirname "$0")/lib.sh"

KEY="" NAME="" CREATE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --key) KEY="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --create-project) CREATE=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done
echo "$KEY" | grep -Eq '^[A-Z][A-Z0-9]{1,9}$' || fail "--key must be 2-10 capital letters or digits (e.g. APP)"
[ -n "$NAME" ] || NAME="$KEY"
need curl; need jq
for v in JIRA_SITE JIRA_EMAIL JIRA_API_TOKEN; do
  [ -n "${!v:-}" ] || fail "$v is not set. Set JIRA_SITE, JIRA_EMAIL and JIRA_API_TOKEN in your own terminal, then run this again."
done
SITE="${JIRA_SITE#https://}"; SITE="${SITE%/}"
API="https://$SITE/rest/api/3"

# jira METHOD PATH [JSON]  -> prints body; sets HTTP_CODE
jira() {
  local method="$1" path="$2" data="${3:-}" out
  out="$(mktemp)"
  if [ -n "$data" ]; then
    HTTP_CODE="$(curl -sS -o "$out" -w '%{http_code}' -u "$JIRA_EMAIL:$JIRA_API_TOKEN" -X "$method" \
      -H 'Accept: application/json' -H 'Content-Type: application/json' --data "$data" "$API$path")"
  else
    HTTP_CODE="$(curl -sS -o "$out" -w '%{http_code}' -u "$JIRA_EMAIL:$JIRA_API_TOKEN" -X "$method" \
      -H 'Accept: application/json' "$API$path")"
  fi
  cat "$out"; rm -f "$out"
}

say "Ticket system: Jira on $SITE, project $KEY"

ME="$(jira GET /myself)"
[ "$HTTP_CODE" = "200" ] || fail "Jira refused the login (HTTP $HTTP_CODE). Check JIRA_SITE, JIRA_EMAIL and the token."
ACCOUNT_ID="$(printf '%s' "$ME" | jq -r .accountId)"
ok "logged in to Jira"

# 1. Project
jira GET "/project/$KEY" >/dev/null
if [ "$HTTP_CODE" = "200" ]; then
  skip "project $KEY exists"
elif [ "$CREATE" = "1" ]; then
  BODY="$(jq -n --arg k "$KEY" --arg n "$NAME" --arg lead "$ACCOUNT_ID" \
    '{key:$k, name:$n, leadAccountId:$lead, projectTypeKey:"software", projectTemplateKey:"com.pyxis.greenhopper.jira:gh-simplified-kanban-classic", assigneeType:"PROJECT_LEAD"}')"
  if [ "$DRY_RUN" = "1" ]; then plan "create Kanban project $KEY ($NAME)"; else
    jira POST /project "$BODY" >/dev/null
    case "$HTTP_CODE" in 200|201) ok "created project $KEY" ;; *) fail "Jira refused to create the project (HTTP $HTTP_CODE). Create it in the browser (Projects → Create project → Kanban) with key $KEY, then run this again without --create-project." ;; esac
  fi
else
  fail "Project $KEY does not exist. Create it in Jira (Projects → Create project → Kanban), or run again with --create-project."
fi

# 2. "Won't do" resolution
RES="$(jira GET /resolution)"
if printf '%s' "$RES" | jq -e '.[] | select(.name=="Won'"'"'t do")' >/dev/null 2>&1; then
  skip "resolution \"Won't do\" exists"
elif [ "$DRY_RUN" = "1" ]; then
  plan "add the \"Won't do\" resolution"
else
  jira POST /resolution '{"name":"Won'"'"'t do","description":"Closed with a reason, not built."}' >/dev/null
  case "$HTTP_CODE" in 200|201) ok "added resolution \"Won't do\"" ;;
    *) warn "Jira refused to add the resolution (HTTP $HTTP_CODE; it needs Jira admin). Add it by hand: Settings → Issues → Resolutions → Add \"Won't do\"." ;; esac
fi

# 3. Practice ticket
SUMMARY="Practice: run the build loop once"
FOUND="$(jira GET "/search/jql?jql=$(jq -rn --arg q "project = $KEY AND summary ~ \"Practice run the build loop\"" '$q|@uri')&maxResults=1&fields=key" | jq -r '.issues[0].key // empty' 2>/dev/null || true)"
if [ -n "$FOUND" ]; then
  skip "practice ticket $FOUND exists"
elif [ "$DRY_RUN" = "1" ]; then
  plan "open ticket \"$SUMMARY\""
else
  DESC="Run one change through the whole build loop: branch named after this ticket, one small change committed as '$KEY-N: practice change', a PR into develop with the test and ticket-key checks green, merged on the decider's word."
  BODY="$(jq -n --arg k "$KEY" --arg s "$SUMMARY" --arg d "$DESC" \
    '{fields:{project:{key:$k}, summary:$s, issuetype:{name:"Task"}, description:{type:"doc",version:1,content:[{type:"paragraph",content:[{type:"text",text:$d}]}]}}}')"
  NEW="$(jira POST /issue "$BODY")"
  case "$HTTP_CODE" in 200|201) ok "practice ticket $(printf '%s' "$NEW" | jq -r .key)" ;;
    *) warn "could not open the practice ticket (HTTP $HTTP_CODE). Open it by hand: \"$SUMMARY\"." ;; esac
fi
