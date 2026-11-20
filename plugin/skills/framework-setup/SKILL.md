---
name: framework-setup
description: Sets up a software project for the Human-led AI development framework (step 4, Setup) — Gitflow branches, merge rules, CI with unit tests, ticket-key commits, AI review, ticket system (Jira or GitHub Issues), secrets protection, a shared AGENTS.md/CLAUDE.md rule file and a practice ticket — then asks for the first idea and opens a brainstorm or a design chat for it. Use when the user asks to set up, bootstrap or configure a project with this framework. The user only logs in, creates accounts and clicks app installs; you do the rest.
---

# Framework setup

You are setting up the user's project so an AI can work in it safely from the first ticket. This is step 4 of the framework (https://github.com/Alcagoita/human-led-ai-framework/blob/main/FRAMEWORK.md). The person decides; you do the work.

Helper scripts are in the `scripts/` folder next to this file, and the files they install are in `files/`. Run scripts with `bash <path>`. Every script accepts `--dry-run` and is safe to run twice.

## Hard rules

- **Never see a secret.** Never ask the user to paste a password, token or key into the chat, and never print one. Tokens go into the user's own terminal as environment variables, or through a login command the user runs.
- **Never pay, accept terms or create accounts for the user.** When a step needs that, stop, give the exact link, and wait for the user to say it is done.
- **Never force-push, never push to `main` or `develop` after the rules are on, never delete branches or repositories.**
- **Ask before anything public:** creating a public repository, or sending the anonymous setup count.
- **Show the plan before changing anything.** Run the scripts with `--dry-run` first, show the user what will happen, then run them for real on their OK.
- If a step fails, say what failed and why, keep going with the steps that do not depend on it, and list it in the report. Never pretend a step worked.

## Phase 1 — Explain and check

1. In three or four sentences, tell the user what you will set up and what they will need to do themselves (log in to GitHub, maybe create a Jira API token, click Install on CodeRabbit).
2. Run `scripts/check-tools.sh`. If `git` or `gh` is missing, give the install command for their system and wait.
3. If `gh` is not logged in, ask the user to run `gh auth login` in their terminal (in Claude Code they can type `! gh auth login`). Wait until `gh auth status` succeeds.

## Phase 2 — Ask (one round, use a question tool if you have one)

Ask these together, with a sensible default for each:

1. **Project name** and **GitHub repository** (`owner/name`). Default: the current folder name under their GitHub account. Is it **public or private**? Explain: on GitHub's free plan, merge rules (rulesets) only work on public repositories; private ones need a paid plan.
2. **Stack:** `node` (includes React, React Native, Next.js), `python`, or `other`.
3. **Solo or team.** Solo: no review approval required (the owner cannot approve their own PR). Team: one approval required.
4. **Ticket system:** `github` (GitHub Issues, nothing to sign up for) or `jira`. For Jira, also ask the **project key** (2–10 capital letters, e.g. `APP`) and whether the Jira project already exists.
5. **Beta platform** now, later, or not needed (apps only).
6. **Anonymous setup count:** "May I send one anonymous count to the framework author when setup finishes? It contains no data about you or the project, only +1." Default: ask, never assume yes.

## Phase 3 — Install the files

1. Make sure the folder is a git repository with a `main` branch. If it is empty, `git init -b main`.
2. Dry run, then real run:
   `scripts/install-files.sh --stack <stack> --tickets <github|jira> --key <KEY or GH> --mode <solo|team>`
   This writes: CI workflow (`test` job), ticket-key check (`ticket-key` job), PR template, issue templates (GitHub Issues) or ticket templates in `docs/templates/` (Jira), `.coderabbit.yaml`, a `commit-msg` hook in `.githooks/` (turned on with `core.hooksPath`), and a secrets block in `.gitignore`.
3. Commit on `main` with the message `<KEY>-0: framework setup` for Jira, or `#0: framework setup` for GitHub Issues. (`-0` / `#0` is the setup's own ticket key; the hook accepts it.)

## Phase 4 — GitHub

Dry run, then real run:
`scripts/github-setup.sh --repo <owner/name> --visibility <public|private> --mode <solo|team>`

It creates the repository if needed and pushes, creates `develop` and makes it the default branch, turns on delete-branch-on-merge, secret scanning and push protection where the plan allows, and adds one ruleset for `main` and `develop`: no direct pushes, no deletion, a pull request is required, checks `test` and `ticket-key` must pass, and only admins (the decider) can merge past the rules, through a PR (`gh pr merge --admin`). Report anything the plan refused.

## Phase 5 — Ticket system

**GitHub Issues:** run `scripts/github-issues-setup.sh --repo <owner/name>`. It adds the labels (`decision`, `work`, `feedback`, `bug`, `wont-do`) and opens the practice issue.

**Jira:**
1. If the user has no Atlassian account, send them to https://www.atlassian.com/software/jira/free and wait.
2. Ask them to create an API token at https://id.atlassian.com/manage-profile/security/api-tokens and to run, **in their own terminal before the next step** (not in this chat):
   `export JIRA_SITE=<their-site>.atlassian.net JIRA_EMAIL=<their-email> JIRA_API_TOKEN=<token>`
   In Claude Code they can restart the session from that terminal, or prefix the script call with the variables themselves using `!`.
3. Run `scripts/jira-setup.sh --key <KEY> --name "<project name>" [--create-project]`. It creates the project if asked, adds the "Won't do" resolution (needs Jira admin; on refusal, tell the user to add it under Settings → Issues → Resolutions), and opens the practice ticket.
4. If an Atlassian MCP connector is available in this session, you may use it for tickets instead of the token.

## Phase 6 — AI review

1. Send the user to https://github.com/apps/coderabbitai/installations/new to install CodeRabbit on this repository (free for public repositories). Wait for "done".
2. `.coderabbit.yaml` is already in the repo. Nothing else to configure.

## Phase 7 — The rule file (interview)

Interview the user, one question at a time, short answers welcome:

1. In two or three sentences, what is the product and its main idea?
2. Which few promises make it unique? Example: "What we show is always real." (2–4 promises)
3. Which model facts does everything stand on? Example: "A task never expires." (3–6 facts)
4. Anything the AI must never do in this project?

Then write **`AGENTS.md`** from `files/AGENTS.template.md`, filling every `<…>` with their answers and the choices from phase 2 (integration branch `develop`, ticket key, commit format). Write **`CLAUDE.md`** containing only the line `@AGENTS.md`, so Claude Code and Codex read the same rules and never drift apart. Show both files to the user before committing. Commit them on a branch named `<KEY>-0-rule-file` (or `0-rule-file`) and open a PR into `develop`; this is also the first real use of the merge rules.

## Phase 8 — Optional parts

- **Beta platform (apps):** if the user chose it, explain the options (Firebase App Distribution, Google Play internal testing, TestFlight). For Firebase, ask them to run `firebase login`, then help them add the app with `firebase apps:create`. Store accounts (Play Console, Apple Developer) need fees and identity checks: link them and stop.
- **Team only, measurement:** suggest a platform that measures how the team uses AI, not individual output (Span, https://www.span.app/, is one example). Account and connections are the user's.

## Phase 9 — Practice ticket and report

1. Walk the user through the practice ticket once: branch named after it, a one-line change, PR into `develop`, checks run, the user says merge, `gh pr merge <n> --merge --admin` (solo) or a normal merge after approval (team). This is the framework's "done when" for setup.
2. Write `SETUP_REPORT.md` in the repo: the framework's step 4 checklist, each item ticked or marked with what is still waiting on the user and the exact link. Commit it with the practice change or in its own PR.

## Phase 10 — Anonymous count

Only if the user said yes in phase 2: run `scripts/count-install.sh`. It sends one request with no body and no project data. If it fails, ignore it silently; it must never block setup.

## Phase 11 — The first idea

Setup is the frame; the idea is the first stroke. Hand over gently. Speak like a calm companion: short, warm, questions over labels, no pressure, no jargon ("idea check", "persona", "phase" stay out of what you say).

1. Say the setup is done in one sentence, then ask:
   > **"What's the idea? Say it the way you'd tell a friend."**
   Take whatever comes, even one line. If the rule file already holds the product's main idea, offer it back: "Is it this one, or something new?"
2. Write it into a decision ticket straight away (GitHub Issues: an issue labelled `decision`, titled `Decide: <idea in a few words>`; Jira: a Task with that summary). The idea is safe before anything else happens.
3. Ask:
   > **"Want to talk it through first, or start sketching?"**
   - **Talk it through** — a brainstorm with a brand expert and a UX designer already at the table.
   - **Start sketching** — straight to the design, one simple question to begin.
   - **Not now** — it's saved in the ticket; it can wait.
4. Ask where, once: "Should I open it in Claude or in ChatGPT?" Default to Claude in Claude Code and ChatGPT in Codex. Offer "right here" too: then run the same conversation in this session instead of opening a window.
5. Save the idea to a temporary file and the product context (main idea, promises and model facts from `AGENTS.md`, if written) to another, then run:
   `scripts/open-idea.sh --mode <brainstorm|design> --where <claude|chatgpt> --idea-file <file> --context-file <file> --ticket <ticket ref>`
   It opens a new chat in the browser already started (brainstorm: the practical look, then the brand expert and the UX designer, then questions for the owner; design: one opening question, then a first sketch). The prompt is also copied to the clipboard in case the chat opens empty. Delete the temporary files afterwards.
6. Close with one line, in the same voice: "It's open in your browser. When you've decided, paste the outcome into <ticket> — I'll be here for the next step."

Finish with a short summary: what is done, what is waiting on the user, and where to read the framework next (steps 5 to 8).
