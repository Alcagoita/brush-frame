#!/usr/bin/env bash
# Opens a new chat in the browser, already started with the idea: a brainstorm with the
# personas, or a first design sketch. The prompt is also copied to the clipboard as a fallback.
# Usage: open-idea.sh --mode brainstorm|design --where claude|chatgpt --idea-file FILE
#                     [--context-file FILE] [--ticket REF] [--print] [--dry-run]
#   --print     show the prompt and the link, open nothing (for checking)
#   --dry-run   say what would happen, open and copy nothing
set -euo pipefail
. "$(dirname "$0")/lib.sh"

MODE="" WHERE="claude" IDEA_FILE="" CONTEXT_FILE="" TICKET="the decision ticket" PRINT=0
while [ $# -gt 0 ]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --where) WHERE="$2"; shift 2 ;;
    --idea-file) IDEA_FILE="$2"; shift 2 ;;
    --context-file) CONTEXT_FILE="$2"; shift 2 ;;
    --ticket) TICKET="$2"; shift 2 ;;
    --print) PRINT=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) fail "Unknown option: $1" ;;
  esac
done
case "$MODE" in brainstorm|design) ;; *) fail "--mode must be brainstorm or design" ;; esac
case "$WHERE" in claude|chatgpt) ;; *) fail "--where must be claude or chatgpt" ;; esac
[ -s "$IDEA_FILE" ] || fail "--idea-file must point to a file with the idea in it"
need jq

TEMPLATE="$(skill_dir)/files/prompts/$MODE.md"
CONTEXT="(Nothing written down yet.)"
[ -n "$CONTEXT_FILE" ] && [ -s "$CONTEXT_FILE" ] && CONTEXT="$(cat "$CONTEXT_FILE")"

PROMPT="$(jq -Rrs --rawfile idea "$IDEA_FILE" --arg ctx "$CONTEXT" --arg ticket "$TICKET" \
  'gsub("__IDEA__"; ($idea | rtrimstr("\n"))) | gsub("__CONTEXT__"; $ctx) | gsub("__TICKET__"; $ticket)' "$TEMPLATE")"
ENC="$(printf '%s' "$PROMPT" | jq -Rrs '@uri')"

case "$WHERE" in
  claude)  BASE="https://claude.ai/new";  URL="https://claude.ai/new?q=$ENC" ;;
  chatgpt) BASE="https://chatgpt.com/";   URL="https://chatgpt.com/?q=$ENC" ;;
esac
# Very long links can be cut by the browser; then open a blank chat and rely on the clipboard.
if [ "${#URL}" -gt 7500 ]; then URL="$BASE"; LONG=1; else LONG=0; fi

if [ "$DRY_RUN" = "1" ]; then
  plan "open a new $MODE chat in $WHERE (${#URL}-character link$([ "$LONG" = "1" ] && echo ', too long: a blank chat'))"
  plan "copy the prompt to the clipboard as a fallback"
  exit 0
fi

if [ "$PRINT" = "1" ]; then
  printf '%s\n\n--- link (%s characters) ---\n%s\n' "$PROMPT" "${#URL}" "$URL"
  exit 0
fi

COPIED=0
for c in pbcopy wl-copy "xclip -selection clipboard" clip.exe; do
  if command -v ${c%% *} >/dev/null 2>&1; then printf '%s' "$PROMPT" | $c && COPIED=1 && break; fi
done

OPENED=0
for o in open xdg-open wslview; do
  if command -v "$o" >/dev/null 2>&1; then "$o" "$URL" >/dev/null 2>&1 && OPENED=1 && break; fi
done

[ "$OPENED" = "1" ] && ok "opened a new chat in your browser" || say "  Open this link: $URL"
[ "$COPIED" = "1" ] && ok "the prompt is also on your clipboard"
if [ "$LONG" = "1" ] || [ "$OPENED" = "0" ]; then
  say "  If the chat starts empty, paste the prompt (it is on your clipboard)."
fi
