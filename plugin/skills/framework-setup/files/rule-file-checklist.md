# Rule file: create or update

The rule file is what every AI session reads first. Short and true beats long and complete: every line costs attention in every session.

## Where things live

| What | Where | Why |
|---|---|---|
| Product idea, promises, model facts, workflow, rules | the rule file: `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex | One file, for the tool the project uses. Both only when people use both tools: then the rules live in `AGENTS.md` and `CLAUDE.md` holds `@AGENTS.md` |
| Claude-only notes, when both files exist | `CLAUDE.md`, under the import | Codex never needs them |
| Decisions and their reasons | the decision ticket | The ticket is the memory; the rule file links it |
| Ticket status, sprint progress, "what we're doing now" | nowhere in the rule file | It goes stale within days and misleads the AI; the ticket system holds status |
| One person's preferences ("explain less", "answer in Portuguese") | the AI tool's own memory | Personal, not the team's |
| Long reference (API notes, data rules for one folder) | a file in that folder, e.g. `api/CLAUDE.md` (`api/AGENTS.md` in Codex), or `docs/` linked from the rule file | Read when work touches it, not in every session |

## When there is none: create

Write the rule file from `rule-file.template.md` with the interview answers: `CLAUDE.md` in Claude Code, `AGENTS.md` in Codex. Only that one.

## When one exists: update, never overwrite

1. Read the existing `CLAUDE.md`, `AGENTS.md` and any nested ones whole. Keep the person's content; it is theirs.
2. Update the file this tool reads. If the project has only the other tool's file, keep the rules in one place both read: `AGENTS.md`, with `CLAUDE.md` holding `@AGENTS.md`. Moving content out of an existing `CLAUDE.md` is their choice; if they say no, add the framework sections where they are.
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
