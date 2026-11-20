# <Project> — rules for the AI

Read by every AI tool in this project. `CLAUDE.md` imports this file, so Claude Code and Codex follow the same rules. Built on the Human-led AI development framework: https://github.com/Alcagoita/human-led-ai-framework

## What this product is
<Two or three sentences: the main idea.>

## Product promises
<The few rules that make the product unique, as a list. A change that breaks one needs a decision ticket first.>

## Model facts
<The rules the product stands on, as a list. Each links to its decision ticket when there is one.>

## Workflow
- Ticket system: <Jira project KEY | GitHub Issues>. No work without a ticket.
- Branch from `develop`, named `<KEY-12-short-description | 12-short-description>`.
- Every commit and PR title starts with the ticket key: `<KEY-12: … | #12: …>`. A hook and a CI check enforce it.
- Move the ticket at each step: in progress when you start, in review when the PR opens, done when it merges.
- Open the PR into `develop`. Checks `test` and `ticket-key` must pass. AI review runs on every PR; commit and push fixes straight away.
- Releases: a `release/X.Y.Z` branch from `develop`, merged into `main` and back into `develop`, tagged, with notes. Urgent production fixes: `hotfix/…` from `main`.

## Rules
1. One ticket at a time. Do not start the next until the current PR is merged.
2. The ticket is the spec. Nothing outside it. If something is unclear, propose a change to the ticket instead of guessing.
3. Check the ticket's real status in the ticket system before starting. Never trust a copy.
4. Never merge. Merging is the decider's word: <the owner | the product manager>.
5. Unit tests for any logic, before the PR. Not during quick visual tweaks.
6. Small slice first: run any job over a lot of data on a sample, check, then widen.
7. When something breaks, ask what the person already knows before hunting. Root cause first, then the fix, then the tests.
8. Never put keys, tokens or passwords in code, prompts, chat or this file. They live in local files that git ignores.
9. Decisions go in tickets and in this file, never only in chat: the next session cannot see the chat.
<Anything the AI must never do in this project, from the interview.>

## Corrections
<Rules added in step 7, each as: the rule — Why: … — Source: ticket, date — Review by: date.>
