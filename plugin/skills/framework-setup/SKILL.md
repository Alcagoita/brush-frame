---
name: framework-setup
description: Sets up a software project for Brush Frame (step 4, Setup) — Gitflow branches, merge rules, CI with unit tests, ticket-key commits, AI review, ticket system (Jira or GitHub Issues), secrets protection and a practice ticket — then takes the first idea, suggests skills for what is being built (web, mobile, backend), creates or tidies the shared AGENTS.md/CLAUDE.md rule file and its memory rules, and opens a brainstorm or design chat for the idea. Use when the user asks to set up, bootstrap or configure a project with this framework. The user only logs in, creates accounts and clicks app installs; you do the rest.
---

# Framework setup

You are setting up the user's project so an AI can work in it safely from the first ticket, then helping them start on their idea. This is step 4 of the framework (https://github.com/Alcagoita/human-led-ai-framework/blob/main/FRAMEWORK.md), handing over to steps 1 and 2. The person decides; you do the work.

Helper scripts are in the `scripts/` folder next to this file, and the files they install or you read are in `files/`. Run scripts with `bash <path>`. Every script accepts `--dry-run` and is safe to run twice.

## Voice

Speak like a calm companion: short, warm, plain. Questions over labels ("What are you building?", not "Select platform"). No pressure: every optional part can wait. Keep the framework's words ("idea check", "persona", "phase", "gate") out of what you say to the person.

## Hard rules

- **Never see a secret.** Never ask the user to paste a password, token or key into the chat, and never print one. Tokens go into the user's own terminal as environment variables, or through a login command the user runs.
- **Never pay, accept terms or create accounts for the user.** When a step needs that, stop, give the exact link, and wait for the user to say it is done.
- **Never install a plugin or skill the person did not say yes to.**
- **Never overwrite an existing rule file** (`CLAUDE.md`, `AGENTS.md`). Update it with the person, through a PR.
- **Never force-push, never push to `main` or `develop` after the rules are on, never delete branches or repositories.**
- **Ask before anything public:** creating a public repository, or sending the anonymous setup count.
- **Show the plan before changing anything.** Run the scripts with `--dry-run` first, show the user what will happen, then run them for real on their OK.
- If a step fails, say what failed and why, keep going with the steps that do not depend on it, and list it in the report. Never pretend a step worked.

## Phase 1 — Explain and check

1. In three or four sentences, say what you will set up and what the person will do themselves (log in to GitHub, maybe create a Jira API token, click Install on CodeRabbit).
2. Run `scripts/check-tools.sh`. If `git` or `gh` is missing, give the install command for their system and wait.
3. If `gh` is not logged in, ask the user to run `gh auth login` in their terminal (in Claude Code they can type `! gh auth login`). Wait until `gh auth status` succeeds.
4. Note whether `CLAUDE.md` or `AGENTS.md` already exist in the project (and any nested ones). You will come back to them in phase 10.
5. **Already set up?** If the repository already has `.github/ticket-key-pattern` and an `AGENTS.md`, someone set this project up with the framework before. Ask: "This project is already set up. Are you joining it?" On yes, follow **Joining a project** at the end of this file instead of phases 2–13.

## Phase 2 — Ask (one round, use a question tool if you have one)

Ask these together, with a sensible default for each:

1. **What are you building?** A web app, a mobile app, both, a backend or API, or something else (a CLI, a desktop app, a library). Keep the answer: it shapes the stack, the beta question and the skills you suggest later.
2. **What will it be built with?** Offer a default from the answer above: mobile → React Native with Expo (`node`); web → React or Next.js (`node`); backend → ask between `node` and `python`. Anything else → `other`. If code already exists, read `package.json` / `pyproject.toml` and say what you found instead of asking.
3. **Project name** and **GitHub repository** (`owner/name`). Default: the current folder name under their GitHub account. **Public or private?** Explain: on GitHub's free plan, merge rules (rulesets) only work on public repositories; private ones need a paid plan.
4. **Just you, or a team?** Solo: no review approval required (the owner cannot approve their own PR). Team: one approval required.
5. **Where do tasks live?** `github` (GitHub Issues, nothing to sign up for) or `jira`. For Jira, also ask the **project key** (2–10 capital letters, e.g. `APP`) and whether the project already exists.
6. **Beta testers** (only for mobile or both): now, later, or not needed.
7. **Pigment** (optional, say it plainly): "There's an optional tool, Pigment, that shows what each prompt, task and session costs beside the chat, and for a team, the sprint by task. Nothing in the framework needs it. Want it?" No means no: skip phase 11 and never bring it up again.
8. **Anonymous setup count:** "May I send one anonymous count to the framework author when setup finishes? It contains no data about you or the project, only +1." Ask; never assume yes.

## Phase 3 — Install the files

1. Make sure the folder is a git repository with a `main` branch. If it is empty, `git init -b main`.
2. Dry run, then real run:
   `scripts/install-files.sh --stack <node|python|other> --tickets <github|jira> --key <KEY> --mode <solo|team>`
   It writes the CI workflow (`test` job), the ticket-key check (`ticket-key` job), the PR template, issue templates (GitHub Issues) or ticket templates in `docs/templates/` (Jira), `.coderabbit.yaml`, a `commit-msg` hook in `.githooks/` (on through `core.hooksPath`) and a secrets block in `.gitignore`. Existing files are never overwritten.
3. Commit on `main` as `<KEY>-0: framework setup` (Jira) or `#0: framework setup` (GitHub Issues). `-0` / `#0` is the setup's own ticket key; the hook accepts it.

## Phase 4 — GitHub

Dry run, then real run:
`scripts/github-setup.sh --repo <owner/name> --visibility <public|private> --mode <solo|team>`

It creates the repository if needed and pushes, creates `develop` and makes it the default branch, turns on delete-branch-on-merge, secret scanning and push protection where the plan allows, and adds one ruleset for `main` and `develop`: no direct pushes, no deletion, a pull request required, checks `test` and `ticket-key` must pass, and only admins (the decider) merge past the rules, through a PR (`gh pr merge --admin`). Report anything the plan refused.

## Phase 5 — Ticket system

**GitHub Issues:** run `scripts/github-issues-setup.sh --repo <owner/name>`. It adds the labels (`decision`, `work`, `feedback`, `bug`, `wont-do`) and opens the practice issue.

**Jira:**
1. No Atlassian account yet: send them to https://www.atlassian.com/software/jira/free and wait.
2. Ask them to create an API token at https://id.atlassian.com/manage-profile/security/api-tokens and to run, **in their own terminal** (not in this chat):
   `export JIRA_SITE=<their-site>.atlassian.net JIRA_EMAIL=<their-email> JIRA_API_TOKEN=<token>`
   then restart this session from that terminal.
3. Run `scripts/jira-setup.sh --key <KEY> --name "<project name>" [--create-project]`. It creates the project if asked, adds the "Won't do" resolution (needs Jira admin; on refusal, tell them to add it under Settings → Issues → Resolutions) and opens the practice ticket.
4. If an Atlassian MCP connector is available in this session, you may use it for tickets instead of the token.

## Phase 6 — AI review

Send the user to https://github.com/apps/coderabbitai/installations/new to install CodeRabbit on this repository (free for public repositories). Wait for "done". `.coderabbit.yaml` is already in the repo.

## Phase 7 — Practice ticket

Walk the user through the practice ticket once: a branch named after it, a one-line change, a PR into `develop`, checks run, the user says merge, then `gh pr merge <n> --merge --admin` (solo) or a normal merge after approval (team). This is the framework's "done when" for setup. Say in one sentence that the frame is up.

## Phase 8 — The idea

Setup is the frame; the idea is the first stroke.

1. Ask: **"What's the idea? Say it the way you'd tell a friend."** Take whatever comes, even one line.
2. Save it in a decision ticket straight away (GitHub Issues: an issue labelled `decision`, titled `Decide: <idea in a few words>`; Jira: a Task with that summary). The idea is safe before anything else happens.

## Phase 9 — Skills that help

Read `files/skills-map.md`. From what they are building (phase 2) and the idea, pick **at most four** that fit, and offer them in one message:

> "A few things could help with a <mobile app in React Native>:
> – **expo**: builds and store releases
> – **react-native-best-practices**: keeps it fast
> Want any of them?"

Install only the ones they pick, with the line for their tool (Claude Code or Codex) from the map. If none fit, skip this phase without a word.

## Phase 10 — The rule file and memory

Read `files/rule-file-checklist.md` and follow it.

1. **None exists:** say "I'll write the project's rule file — the notes every AI session reads first." Interview, one short question at a time:
   - the main idea (offer back the idea from phase 8: "Is this the heart of it, or is it bigger?");
   - two to four **promises** that make it unique ("What should it always or never do for the person using it?");
   - three to six **model facts** everything stands on ("What's true in it that everything else depends on?");
   - anything the AI must never do in this project.
   Then write `AGENTS.md` from `files/AGENTS.template.md` with their answers and the choices from phase 2, and `CLAUDE.md` holding `@AGENTS.md`.
2. **One exists:** ask **"I found a <CLAUDE.md>. Shall I tidy it and add what's missing, or leave it and start a separate one?"**
   - *Tidy and add*: follow the checklist's update steps. Keep their content, add the missing sections, propose removals one by one with the reason, and say the size before and after.
   - *Separate one*: write `AGENTS.md` fresh, and add `@AGENTS.md` at the top of their existing `CLAUDE.md` with their OK.
3. Either way, include the **Memory** section, so every tool files corrections, decisions and personal preferences in the same places.
4. Show the files, then commit them on a branch (`<KEY>-0-rule-file` or `0-rule-file`) and open a PR into `develop`.

## Phase 11 — Pigment (only if they said yes)

Pigment is a separate tool (https://github.com/Alcagoita/pigment). The framework never depends on it.

1. Install it: `claude plugin marketplace add Alcagoita/pigment` then `claude plugin install pigment@pigment` (Claude Code only).
2. Ask: **"Where should Pigment keep the numbers: in your cloud, or just on this computer?"** A team always uses the cloud (the sprint view needs one shared place); for someone alone, say the cloud is safer and local is fine.
3. **Just on this computer:** write `.pigment/config.json` as `{"version": 1, "storage": "local"}` and `.pigment/.gitignore` with `*.jsonl`. Commit both.
4. **In the cloud:** ask "Which cloud do you already use?"
   - **Cloudflare, or none yet:** clone Pigment to a temporary folder and run `server/setup.sh --project <this project> --dry-run`, show the plan, then run it for real. The person logs in to Cloudflare in the browser; the script creates the database, the team key and the server and writes `.pigment/config.json`. The key is saved to a private file under `~/.pigment/keys/` and never printed: **never open or read that file yourself.** Tell the person to open it, add the key in `/config` under Pigment, and share it with the team privately.
   - **Supabase, Firebase or another:** say plainly that Pigment's server runs on Cloudflare today and the others are planned; offer Cloudflare's free plan or local for now.
   - Commit `.pigment/` and `.claude/settings.json` (the script adds Pigment there, so every developer who opens the project is offered it).
5. Manager view: ask them to set **View** to `manager` in `/config` under Pigment, plus the Jira site, project, email and token for the sprint list (Jira only).

## Phase 12 — Optional parts

- **Beta testers** (if they said now): explain the options (Firebase App Distribution, Google Play internal testing, TestFlight). For Firebase, ask them to run `firebase login`, then help add the app with `firebase apps:create`. Store accounts need fees and identity checks: link them and stop.
- **Team only, measurement:** suggest a platform that shows how the team uses AI, not individual output (Span, https://www.span.app/, is one example). Account and connections are the user's.

## Phase 13 — Talk it through, or start sketching

1. Ask: **"Want to talk it through first, or start sketching?"**
   - **Talk it through**: a brainstorm with a brand expert and a UX designer already at the table.
   - **Start sketching**: straight to the design, one simple question to begin. Mention what they are building ("a first screen for the phone").
   - **Not now**: it's saved in the ticket; it can wait.
2. Ask where, once: "Open it in Claude or in ChatGPT?" Default to Claude in Claude Code and ChatGPT in Codex. Offer "right here" too: then run the same conversation in this session instead of opening a window.
3. Write the idea to a temporary file, and the context (what they are building, the main idea, promises and model facts from `AGENTS.md`) to another, then run:
   `scripts/open-idea.sh --mode <brainstorm|design> --where <claude|chatgpt> --idea-file <file> --context-file <file> --ticket <ticket ref>`
   It opens a new chat already started and copies the prompt to the clipboard in case the chat opens empty. Delete the temporary files afterwards.

## Phase 14 — Report, count, close

1. Write `SETUP_REPORT.md`: the framework's step 4 checklist, each item ticked or marked with what is still waiting on the user and the exact link; the skills installed; the rule file created or updated; where Pigment keeps its numbers, if they chose it. End it with a **For developers joining** section: install the AI tool, clone the repo, run the setup skill (it finds the project already set up), and, if Pigment's numbers live in the cloud, ask the setup owner for the team key. Commit it in its own PR.
2. Only if the user said yes in phase 2: run `scripts/count-install.sh`. It sends one request with no body and no project data. If it fails, ignore it; it never blocks setup.
3. Close with one line in the same voice, e.g. "It's open in your browser. When you've decided, paste the outcome into <ticket> — I'll be here for the next step." Then a short list of anything still waiting on them.

## Joining a project

The project was set up already; this person is joining it, usually as a developer. Do only what is personal to their computer. Change nothing shared without asking.

1. Read `SETUP_REPORT.md` and `AGENTS.md` so you know the ticket system, the branch rules and the recommended skills.
2. Run `scripts/check-tools.sh`; make sure `gh` is logged in.
3. Turn on the commit hook for this clone: `git config core.hooksPath .githooks`.
4. Ticket system access: GitHub Issues needs nothing more. Jira: send them to the project's Jira site to accept the invite, and, only if they will use the scripts, set the `JIRA_*` variables in their own terminal.
5. Offer the skills listed in `SETUP_REPORT.md`, with the same rule: at most four, installed only on a yes.
6. **Pigment, only if the project uses it** (`.pigment/config.json` exists): install it, then
   - `"storage": "cloud"`: "This project keeps its numbers in the team's cloud. Ask whoever set it up for the team key, then add it in `/config` under Pigment, with your name." Pigment shows the same steps in its pane and keeps counting until the key is in.
   - `"storage": "local"`: nothing to do; it counts on their computer.
7. Show them the framework's build loop in three lines (ticket, branch, PR into `develop`, the decider merges), and offer a first ticket.
8. Nothing is committed in this path unless they ask.
