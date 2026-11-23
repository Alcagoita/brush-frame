# Starter rule file

Used in step 4. One per AI tool, same content in each. It grows in step 7; keep it short enough that every rule is read.

```markdown
# <Project> — rules for the AI

## What this product is
<Two or three sentences: the main idea.>

## Product promises
<The few rules that make the product unique, e.g. "What we show is always real." A change that breaks one needs a decision ticket.>

## Model facts
<The rules the product stands on. Each links to its decision ticket.>

## Workflow
- Branch from <integration branch>, named <ticket key>-<short description>.
- Commits start with the ticket key.
- Move the ticket at each step: in progress, in review, done.

## Rules
1. <One ticket at a time (don't start the next until the current PR is merged) | several at once | each developer chooses, kept in their own tool memory.> Always one ticket per branch and per PR.
2. The ticket is the spec. If something is unclear, propose a change to the ticket instead of guessing.
3. Check the ticket's real status before starting. Never trust a copy.
4. Small slice first: run any large job on a sample, check, then widen.
5. Unit tests for logic before the PR. Not during quick visual tweaks.
6. Never merge without the decider's word.

## Design system
<Tokens, type, spacing. Never hard-code a value.>
```
