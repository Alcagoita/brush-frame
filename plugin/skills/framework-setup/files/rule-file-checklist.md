# Rule file: create or update

The rule file is what every AI session reads first. Short and true beats long and complete: every line costs attention in every session.

## Where things live

| What | Where | Why |
|---|---|---|
| Product idea, promises, model facts, workflow, rules | `AGENTS.md` | Shared, versioned, read by Codex; `CLAUDE.md` imports it with `@AGENTS.md` |
| Claude-only notes (a Claude tool, a Claude command) | `CLAUDE.md`, under the import | Codex never needs them |
| Decisions and their reasons | the decision ticket | The ticket is the memory; the rule file links it |
| Ticket status, sprint progress, "what we're doing now" | nowhere in the rule file | It goes stale within days and misleads the AI; the ticket system holds status |
| One person's preferences ("explain less", "answer in Portuguese") | the AI tool's own memory | Personal, not the team's |
| Long reference (API notes, data rules for one folder) | a file in that folder, e.g. `api/AGENTS.md`, or `docs/` linked from the rule file | Read when work touches it, not in every session |

## When there is none: create

Write `AGENTS.md` from `AGENTS.template.md` with the interview answers, and `CLAUDE.md` holding `@AGENTS.md`.

## When one exists: update, never overwrite

1. Read the existing `CLAUDE.md`, `AGENTS.md` and any nested ones whole. Keep the person's content; it is theirs.
2. If only `CLAUDE.md` exists, offer to move its shared content into `AGENTS.md` and leave `CLAUDE.md` as `@AGENTS.md` plus any Claude-only notes, so Codex reads the same rules. Their choice; if they say no, add the framework sections to `CLAUDE.md` itself.
3. Add what is missing from the template: main idea, product promises, model facts, workflow (ticket key, branches, merge rule), the numbered rules, a Corrections section.
4. Propose removals, each with its reason, and remove only the ones they agree to:
   - status copies (ticket states, sprint tables, "current work");
   - the same rule said twice;
   - facts the code or git history already shows (file lists, past fixes);
   - rules whose reason is gone ("No dogmas": a rule stays because its reason still holds);
   - long reference that only one folder needs (move it to a nested file and link it).
5. Say the size before and after, in lines and roughly in tokens (characters ÷ 4).
6. Show the diff, then commit it on a branch and open a PR into `develop`. Never push the rule file straight to a protected branch.

## Memory

Add a short **Memory** section to the rule file, so every tool files things the same way:

> Corrections that should hold for everyone become rules here (Corrections section), with why, the ticket and a review date. Decisions go in tickets. Personal preferences stay in your own tool's memory. Never store ticket status, keys or tokens in any of them.
