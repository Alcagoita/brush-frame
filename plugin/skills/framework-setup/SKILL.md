---
name: framework-setup
description: Sets up a software project for Brush Frame (step 4, Setup) — Gitflow branches, merge rules, CI with unit tests, ticket-key commits, AI review, ticket system (Jira or GitHub Issues), secrets protection and a practice ticket — then takes the first idea, suggests skills for what is being built (web, mobile, backend), creates or tidies the shared AGENTS.md/CLAUDE.md rule file and its memory rules, and opens a brainstorm or design chat for the idea. Use when the user asks to set up, bootstrap or configure a project with Brush Frame or this framework. Works for someone who has never built software (it asks first, then explains in plain words and decides the technical choices) as well as for developers. The user only logs in, creates accounts and clicks app installs; you do the rest.
---

# Framework setup

You are setting up the user's project so an AI can work in it safely from the first ticket, then helping them start on their idea. This is step 4 of the framework (https://github.com/Alcagoita/brush-frame/blob/main/FRAMEWORK.md), handing over to steps 1 and 2. The person decides; you do the work.

Helper scripts are in the `scripts/` folder next to this file, and the files they install or you read are in `files/`. Run scripts with `bash <path>`. Every script accepts `--dry-run` and is safe to run twice.

## Voice

Speak like a calm companion: short, warm, plain. Questions over labels ("What are you building?", not "Select platform"). No pressure: every optional part can wait. Keep the framework's words ("idea check", "persona", "phase", "gate") out of what you say to the person.

## First time? Plain words

The first question of the setup is **"Have you built software before?"** (Yes / A little / Not yet). For **A little** or **Not yet**, take the first-time path everywhere below:

- **One question at a time**, never a list. Decide everything that has a sensible default and say it in one plain line instead of asking ("I'll keep your tasks in GitHub, so there's nothing else to sign up for.").
- **Every technical word gets one plain line the first time it appears**, then you use it freely:
  - **repository**: the project's folder online, with its whole history;
  - **commit**: a saved step in that history;
  - **branch**: a copy where a change waits for your OK;
  - **the two lanes** (`develop` and `main`): one where finished work comes together, one for what's published. Say it once, when the repository is created; after that you run them yourself (the rule file's Gitflow section) and never ask the person to pick or name a branch;
  - **pull request (PR)**: the page where you look at a change before it goes in;
  - **merge**: saying yes, so the change goes in;
  - **tests** and **checks**: small programs that make sure nothing broke, run on every change;
  - **ticket**: one task, written down, so every change has a reason;
  - **AI review**: a second AI reads each change and comments, like a colleague would.
- **Commands are run with them, one at a time.** Say what a command does before it runs. In Claude Code they can run one themselves by typing `!` and the command (`! gh auth login`). Never paste a block of commands and leave.
- **Installing tools:** give the plain download page first (GitHub's installer for `gh`, Git's for `git`); offer Homebrew (`brew install gh`) only if `brew --version` already works.
- **No jargon in the questions**: not "stack", "owner/name", "rulesets", "CI" or "approval". Ask what they are building, and choose the technical setup from it.
- The experienced path stays as it is: the same steps, the same safety, only the words and the pace change.

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

0. Ask **"Have you built software before?"** (Yes / A little / Not yet). Remember the answer: A little or Not yet means the first-time path (see **First time? Plain words**).
1. In three or four sentences (first-time: three plain ones, e.g. "I'll set up a safe place for your project online and the checks that keep it working. You'll log in to GitHub once and say yes at a few points. Then we'll talk about your idea."), say what you will set up and what the person will do themselves (log in to GitHub, maybe create a Jira API token, click Install on CodeRabbit).
2. Run `scripts/check-tools.sh`. If `git` or `gh` is missing, walk them through installing it with `files/first-steps.md` (the part for their computer), then run the check again.
3. **Where the project will live.** Look at the folder this session started in (`pwd`, `ls -A`):
   - **Empty:** use it.
   - **A project already** (a git repository, or code and a `package.json` / `pyproject.toml`): ask "Shall I set up this project, here?"
   - **Not a project folder** (their home folder, Desktop, Documents, Downloads, or a folder of unrelated files; most people start here): don't use it. Say: "I'll make a folder just for your project, so nothing else on your computer gets mixed in." Ask for the name the friendly way (see **A name for it** below), then create `~/Projects/<name>` (lowercase, words joined with `-`; `mkdir -p`). If it exists and isn't empty, add `-2`. From here on, run every command and script **inside that folder** (`cd` into it first in each command). If the AI tool asks permission to work in that folder, tell them it's the new project folder and to allow it.
   - Tell them, in one line, how to come back to it next time: in the Claude desktop app, choose that folder when starting a session; in a terminal, `cd ~/Projects/<name>` then `claude`. Put the same line in `SETUP_REPORT.md`.
4. If `gh` is not logged in, ask them to run `gh auth login --web --git-protocol https --scopes project` (in Claude Code: `! gh auth login --web --git-protocol https --scopes project`; `project` lets the setup make a GitHub board later without a second login): a code to copy, then **Authorize** in the browser. Wait until `gh auth status` succeeds.
5. Run `scripts/git-identity.sh --dry-run`, then for real: their name and GitHub's private email on commits (only if Git has none yet), and Git allowed to push with the same login.
6. Note whether `CLAUDE.md` or `AGENTS.md` already exist in the project (and any nested ones). You will come back to them in phase 10.
7. **Already set up?** If the repository already has `.github/ticket-key-pattern` and an `AGENTS.md`, someone set this project up with the framework before. Ask: "This project is already set up. Are you joining it?" On yes, follow **Joining a project** at the end of this file instead of phases 2–13.

## A name for it

Naming is often the hardest part, so never make it a blank to fill. Ask: **"Do you already have a name, or shall we find one after you tell me the idea?"**

- **They have one:** use it.
- **Let's find one:** ask the idea now, with phase 8's question ("What's the idea? Say it the way you'd tell a friend."), and keep the answer for phase 8 so you never ask it twice. Offer **three to five names**: short, easy to say and spell, in the language they speak, each with one line on why it fits. They can pick one, mix two, or ask for more.
- **Check before they fall in love with it:** "Shall I check if these are taken?" Then:
  - the GitHub name: `gh repo view <their-login>/<name>` failing means it's free in their account;
  - if you can search the web, look for an app, product or website already using the name, and say what you found in one line each.
  Say plainly it's a quick look, not a legal or trademark check. A taken name is a reason to suggest another, not a dead end.
- The name becomes the folder, the repository and the project's name. It can change later; say so, so it doesn't feel final.

## Phase 2 — Ask (one round, use a question tool if you have one)

**First-time path:** ask only questions 1, 3, 5, 7 and 8, one at a time and in plain words. Question 5 is always asked, never decided for them: recommend Jira and let them choose (the wording is in `files/boards.md`, *Which one*). Decide the rest and say each choice in one line: the technical setup from what they are building (question 2), just them (question 4), a simple board with no sprints whatever tool they pick (question 5), and beta testers later (question 6). For question 3, explain public and private plainly: "Public: anyone can see the code, and GitHub's safety rules are free. Private: only you can see it, but some of those rules need a paid GitHub plan." If they are unsure, choose private and say which safety rule they won't have yet.

**Experienced path:** ask these together, with a sensible default for each:

1. **What are you building?** A web app, a mobile app, both, a backend or API, or something else (a CLI, a desktop app, a library). Keep the answer: it shapes the stack, the beta question and the skills you suggest later.
2. **What will it be built with?** Offer a default from the answer above: mobile → React Native with Expo (`node`); web → React or Next.js (`node`); backend → ask between `node` and `python`. Anything else → `other`. If code already exists, read `package.json` / `pyproject.toml` and say what you found instead of asking.
3. **Project name** (asked the way **A name for it** says, unless phase 1 already did) and **GitHub repository** (`owner/name`). Default: the project folder's name under their GitHub account. **Public or private?** Explain: on GitHub's free plan, merge rules (rulesets) only work on public repositories; private ones need a paid plan.
4. **Just you, or a team?** Solo: no review approval required (the owner cannot approve their own PR). Team: one approval required.
5. **Where do tasks live?** Use the wording in `files/boards.md`: Jira is where the framework was proven and is free; GitHub has tasks and boards built in; any tool with the four columns (To do, In development, Testing, Done) works, such as Trello or Linear. Record `github`, `jira` or `other` (with the tool's name). For Jira, also ask the **project key** (2–10 capital letters, e.g. `APP`) and whether the project already exists. For another tool, ask what a task's reference looks like (`ABC-12` → its key; `#12` → none). Experienced path only: **"Do you work in sprints?"** (yes → a board with a backlog and sprints, e.g. Jira Scrum; no → Kanban).
6. **Beta testers** (only for mobile or both): now, later, or not needed.
7. **Pigment**, Brush Frame's companion (https://github.com/Alcagoita/pigment). It runs in Claude Code only: in Codex, say so in one line and skip it.
   - **A team: ask, and recommend it.** It's the easier case: say what it gives a team, then ask. "For a team I'd recommend Pigment. It shows the sprint by task, who's working on what right now, how long each task is taking against its estimate, and quiet sessions where someone may be stuck, and it logs worked time in Jira when a task reaches Testing. It keeps only numbers, never prompts or code. Shall I add it?"
   - **Just them: ask, with the reasons.** "Want Pigment? It sits beside the chat and tells you when the conversation is getting long, so you can carry on in a fresh session without losing anything (**Optimize now**). It also shows what each prompt and task costs. Only numbers, kept on this computer." Either way, it's only added on a yes. A no is a no: skip phase 11, don't bring it up again, and note it in the report.
8. **Anonymous setup count:** "May I send one anonymous count to the framework author when setup finishes? It contains no data about you or the project, only +1." Ask; never assume yes.

## Phase 3 — Install the files

1. Make sure the folder is a git repository with a `main` branch. If it is empty, `git init -b main`.
2. Dry run, then real run:
   `scripts/install-files.sh --stack <node|python|other> --tickets <github|jira|other> [--key <KEY>] --mode <solo|team>` (`--key` for Jira, and for another tool whose tasks look like `KEY-12`)
   It writes the CI workflow (`test` job), the ticket-key check (`ticket-key` job), the PR template, issue templates (GitHub Issues) or ticket templates in `docs/templates/` (Jira), `.coderabbit.yaml`, a `commit-msg` hook in `.githooks/` (on through `core.hooksPath`) and a secrets block in `.gitignore`. Existing files are never overwritten.
3. Commit on `main` as `<KEY>-0: framework setup` (a key) or `#0: framework setup` (numbered tasks). `-0` / `#0` is the setup's own ticket key; the hook accepts it.

## Phase 4 — GitHub

Dry run, then real run:
`scripts/github-setup.sh --repo <owner/name> --visibility <public|private> --mode <solo|team>`

It creates the repository if needed and pushes, creates `develop` and makes it the default branch, turns on delete-branch-on-merge, secret scanning and push protection where the plan allows, and adds one ruleset for `main` and `develop`: no direct pushes, no deletion, a pull request required, checks `test` and `ticket-key` must pass, and only admins (the decider) merge past the rules, through a PR (`gh pr merge --admin`). Report anything the plan refused.

## Phase 5 — Ticket system and its board

Whatever the tool, the result is a board with **To do, In development, Testing, Done**. `files/boards.md` says, per tool, what the setup does and what the person does in the browser when the setup can't; give those steps one at a time and wait for "done".

**GitHub Issues:** run `scripts/github-issues-setup.sh --repo <owner/name>`. It adds the labels (`decision`, `work`, `feedback`, `bug`, `wont-do`) and opens the practice issue. Then the board: create the project and link it (the login already has the `project` permission; only if `gh project list --owner @me` refuses, ask for `gh auth refresh -s project --hostname github.com`) (`files/boards.md`, GitHub), and walk them through its columns.

**Another tool (Trello, Linear, Asana, …):** the setup has no access to it. Walk them through `files/boards.md` for that tool, ask them to create the practice task there and tell you its reference, and use it in phase 7.

**Jira:**

**Jira** (any path ends with the board's columns: `files/boards.md`, Jira; first-time path: the person creates the project in the browser, with those steps).

**Through the Atlassian connector first.** If this session already has an Atlassian connector signed in (an MCP server with Jira tools such as `searchJiraIssuesUsingJql` and `createJiraIssue`), use it and skip the token entirely:
1. Find the site with `getAccessibleAtlassianResources`, and check the project key exists with a search (`project = "<KEY>"`).
2. No project yet: ask them to create it in Jira in the browser (a team-managed Scrum project with that key) and wait; the connector can't create projects.
3. Open the practice ticket with `createJiraIssue`.
4. "Won't do": the connector can't add a resolution. Tell them where it is (Settings → Issues → Resolutions, needs a Jira admin) and list it in the report if it's still missing.

**Without the connector** (or to have the project created for them):
1. No Atlassian account yet: send them to https://www.atlassian.com/software/jira/free and wait.
2. Ask them to create an API token at https://id.atlassian.com/manage-profile/security/api-tokens and to run, **in their own terminal** (not in this chat):
   `export JIRA_SITE=<their-site>.atlassian.net JIRA_EMAIL=<their-email> JIRA_API_TOKEN=<token>`
   then restart this session from that terminal.
3. Run `scripts/jira-setup.sh --key <KEY> --name "<project name>" [--create-project]`. It creates the project if asked, adds the "Won't do" resolution (needs Jira admin; on refusal, tell them to add it under Settings → Issues → Resolutions) and opens the practice ticket.

## Phase 6 — AI review

Send the user to https://github.com/apps/coderabbitai/installations/new to install CodeRabbit on this repository (free for public repositories). Wait for "done". `.coderabbit.yaml` is already in the repo.

## Phase 7 — Practice ticket

Walk the user through the practice ticket once: a branch named after it, a one-line change, a PR into `develop`, checks run, the user says merge, then `gh pr merge <n> --merge --admin` (solo) or a normal merge after approval (team). This is the framework's "done when" for setup. Say in one sentence that the frame is up.

**First-time path: tell it as a short story**, one step per message, and wait for them where they act:
1. "Here's a tiny change, just to see the whole road once: one line in the README."
2. "I made it on a branch, so it waits for your OK instead of going straight in."
3. "Here's the pull request, the page where you look at a change before it goes in." Give the link.
4. "The checks are running: they make sure nothing broke. And an AI is reading it too." Wait until they pass.
5. "Looks good? Say merge, and it goes in." Merge only on their word.
6. "That's the whole road. Every change in your project will travel it, and you'll always have the last word."

## Phase 8 — The idea

Setup is the frame; the idea is the first stroke.

1. Ask: **"What's the idea? Say it the way you'd tell a friend."** Take whatever comes, even one line. If they already told you while finding a name, don't ask again: read it back in one line and ask if anything's missing.
2. Save it in a decision ticket straight away (GitHub Issues: an issue labelled `decision`, titled `Decide: <idea in a few words>`; Jira: a Task with that summary; another tool: give them the title to paste into a new task in **To do**, and ask for its reference). The idea is safe before anything else happens.

3. **A first look.** Most people would rather see something than read about it. Ask: **"Want to see it as a quick mockup?"** (first-time path: always offer it; experienced path: offer it once).
   - On a yes, make **one HTML file**, `docs/mockups/first-look.html`, with one to three screens of the idea: in a phone frame for a mobile app, a browser frame for a website. Use real-looking content from what they said, never lorem ipsum, and mark it clearly as **"A first look. Nothing is built yet."**
   - **The look:** if they described one (colours, mood, an app they like), follow it. If not, use the calm design in `files/calm-design.md` as the base, and say so: "I used a calm, simple look to start; we can make it yours from here."
   - Open it in their browser (`open` on macOS, `xdg-open` on Linux, `start` on Windows), then ask: **"Is it something like this you had in mind?"** Take the answer as it comes (yes, close, or "no, more like…"), change the mockup once if they want, and add what they said to the decision ticket, so the design step starts from it.
   - Commit it on a branch named after the decision ticket and open a pull request into `develop`, with the ticket's reference; merge on their word. On the first-time path, tell it in two lines: "I saved the mockup with your idea. Say merge and it's part of the project."

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

1. **Offer it to everyone who opens this project:** add Pigment to the project's `.claude/settings.json` (create it if missing; keep what's there): `extraKnownMarketplaces.pigment = {"source": {"source": "github", "repo": "Alcagoita/pigment"}}` and `enabledPlugins["pigment@pigment"] = true`. Commit it with `.pigment/` (below). Claude Code then offers to install Pigment when the project is opened, in the desktop app and the terminal alike.
2. **Install it now, for them:** if `claude` runs in this session's shell, run `claude plugin marketplace add Alcagoita/pigment` then `claude plugin install pigment@pigment`. If not (often in the desktop app), give the clicks: **+ → Add plugins → Marketplaces**, add `Alcagoita/pigment`, then **Plugins → pigment → Install**. Either way the pane opens beside the chat; `/pigment` reopens it.
3. **Where the numbers live.** A team always uses the cloud (the sprint view needs one shared place). Someone alone: default to **just on this computer** and say so in one line; offer the cloud only if they ask ("safer if this computer goes"). First-time path: don't ask, use this computer.
4. **Just on this computer:** write `.pigment/config.json` as `{"version": 1, "storage": "local"}` and `.pigment/.gitignore` with `*.jsonl`. Commit both.
5. **In the cloud:** ask "Which cloud do you already use?"
   - **Cloudflare, or none yet:** clone Pigment to a temporary folder and run `server/setup.sh --project <this project> --dry-run`, show the plan, then run it for real. The person logs in to Cloudflare in the browser; the script creates the database, the team key and the server and writes `.pigment/config.json`. The key is saved to a private file under `~/.pigment/keys/` and never printed: **never open or read that file yourself.** Pigment finds the key on this computer by itself. Tell the person to share it with each developer privately (a password manager or a direct message), never in the repository.
   - **Supabase, Firebase or another:** say plainly that Pigment's server runs on Cloudflare today and the others are planned; offer Cloudflare's free plan or local for now.
   - Commit `.pigment/` and `.claude/settings.json` (the script also adds Pigment there).
Commit `.pigment/` and `.claude/settings.json` on a branch (`<KEY>-0-pigment` or `0-pigment`) and open a pull request into `develop`; merge on their word. The branches are protected by now, so never commit them straight to `develop`.
6. **A team's decider:** ask them to set **View** to `manager` in `/config` under Pigment. For the sprint list Pigment uses the Atlassian connector already signed in, with nothing to set; only without the connector does it need the Jira site, email and token in `/config`.

## Phase 12 — Optional parts

- **Beta testers** (if they said now): explain the options (Firebase App Distribution, Google Play internal testing, TestFlight). For Firebase, ask them to run `firebase login`, then help add the app with `firebase apps:create`. Store accounts need fees and identity checks: link them and stop.
- **Team only, more measurement:** beyond Pigment's sprint view, suggest a platform that shows how the team uses AI, not individual output (Span, https://www.span.app/, is one example). Account and connections are the user's.

## Phase 13 — Talk it through, or start sketching

1. Ask: **"Want to talk it through first, or start sketching?"**
   - **Talk it through**: a brainstorm with a brand expert and a UX designer already at the table.
   - **Start sketching**: straight to the design, one simple question to begin. If there's a first-look mockup, start from it and from what they said about it. Mention what they are building ("a first screen for the phone").
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
   - `"storage": "cloud"`: "This project keeps its numbers in the team's cloud. Ask whoever set it up for the team key, then paste it in Pigment's pane when it asks." Pigment keeps counting until the key is in.
   - `"storage": "local"`: nothing to do; it counts on their computer.
7. Show them the framework's build loop in three lines (ticket, branch, PR into `develop`, the decider merges), and offer a first ticket.
8. Nothing is committed in this path unless they ask.
