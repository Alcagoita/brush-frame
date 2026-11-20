#!/usr/bin/env bash
# Sends one anonymous "+1" to the framework's setup counter. Only run with the user's consent.
# The request has no body, no project data and no identifiers. It never fails the setup.
# Usage: count-install.sh [--dry-run]
# Set once the counter Worker is deployed (see counter/README.md). Empty = counting is off.
COUNTER_URL="${FRAMEWORK_COUNTER_URL:-}"

if [ -z "$COUNTER_URL" ]; then
  echo "  skip    the setup counter is not configured yet; nothing was sent."
  exit 0
fi
if [ "${1:-}" = "--dry-run" ]; then
  echo "  plan    POST $COUNTER_URL/v1/setup (no body)"
  exit 0
fi
if curl -fsS -m 5 -X POST "$COUNTER_URL/v1/setup" -o /dev/null 2>/dev/null; then
  echo "  ok      anonymous setup count sent. Thank you."
else
  echo "  skip    the setup counter did not answer; nothing was sent."
fi
exit 0
