# <Project> — rules for the AI

Every AI session in this project reads this file first. Built on Brush Frame: https://github.com/Alcagoita/brush-frame

## What this product is
<Two or three sentences: the main idea.>

## Product promises
<The few rules that make the product unique, as a list. A change that breaks one needs a decision ticket first.>

## Model facts
<The rules the product stands on, as a list. Each links to its decision ticket when there is one.>

## Workflow
- Tasks live in: <Jira project KEY | GitHub Issues | the tool's name and link>. No work without a task.
- The board has four columns: **To do, In development, Testing, Done**. Move the task yourself: **In development** when you start, **Testing** when the pull request opens, **Done** when it merges. If the tool can't be reached from here, tell the person which column to move it to.
- Every commit and pull request title starts with the task's reference: `<KEY-12: … | #12: …>`. A hook and a CI check enforce it.
- Checks `test` and `ticket-key` must pass. AI review runs on every pull request; commit and push its fixes straight away.

## Gitflow: you run it, the person never has to
The project has two protected lanes: `develop`, where finished work comes together, and `main`, what is published. Nobody pushes to either directly; everything arrives through a pull request, and only the decider says merge. You handle every branch below without being asked. Don't ask the person to choose or name a branch, and don't explain Gitflow unless they ask: say what happened in one plain line ("Your change is waiting for your OK here: <link>").

**A task (feature or fix):**
1. Update `develop` (`git switch develop && git pull`).
2. Branch from it: `<KEY-12-short-description | 12-short-description>`.
3. Commit with the reference, push, open the pull request into `develop`.
4. Merge only on the decider's word; the branch is deleted after the merge.

**A release** (when the decider says to publish):
1. From an up-to-date `develop`, branch `release/X.Y.Z`. Pick the version yourself (patch for fixes, minor for features, major only on the decider's word) and say which.
2. On it: bump the version where the project keeps it, and write the release notes from the tasks merged since the last tag, grouped by area.
3. Pull request `release/X.Y.Z` into `main`. On the decider's word, merge.
4. Tag `main`: `git tag -a vX.Y.Z -m "Release vX.Y.Z"` and push the tag; create the release with its notes (`gh release create vX.Y.Z --notes-file …`).
5. Pull request `release/X.Y.Z` back into `develop`, so the version bump isn't lost; merge it, then delete the release branch.

**An urgent fix to what's published** (hotfix):
1. Only when something published is broken and can't wait for the next release, and the decider agrees.
2. Branch `hotfix/short-description` from `main`, with a task for it.
3. Pull request into `main`; merge on the decider's word, tag the next patch version (`v1.4.2` → `v1.4.3`) and release it.
4. Pull request the same branch into `develop` too, so the fix isn't lost; then delete it.

**Never:** push to `main` or `develop`, force-push a shared branch, rewrite published history, delete `main` or `develop`, or merge without the decider's word.

## Rules
1. One ticket at a time. Do not start the next until the current PR is merged.
2. The ticket is the spec. Nothing outside it. If something is unclear, propose a change to the ticket instead of guessing.
3. Check the ticket's real status in the ticket system before starting. Never trust a copy.
4. Never merge on your own. Merge only when the decider says so: <the owner | the product manager>.
5. Unit tests for any logic, before the PR. Not during quick visual tweaks.
6. Small slice first: run any job over a lot of data on a sample, check, then widen.
7. When something breaks, ask what the person already knows before hunting. Root cause first, then the fix, then the tests.
8. Never put keys, tokens or passwords in code, prompts, chat or this file. They live in local files that git ignores.
9. Decisions go in tickets and in this file, never only in chat: the next session cannot see the chat.
<Anything the AI must never do in this project, from the interview.>

## Memory
Corrections that should hold for everyone become rules here, under Corrections, with why, the ticket and a review date. Decisions go in tickets. Personal preferences stay in each person's own tool memory. Never store ticket status, keys or tokens in any of them.

## Corrections
<Rules added in step 7, each as: the rule — Why: … — Source: ticket, date — Review by: date.>
