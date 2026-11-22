# Set up a project in one command

Step 4 of the [framework](FRAMEWORK.md) makes a project safe for AI before the first feature. The setup kit does it for you with your own AI tool. **You only log in, create accounts and click two installs. The AI does the rest.**

## Install

### Claude Code

```
/plugin marketplace add Alcagoita/brush-frame
/plugin install framework-setup@brush-frame
```

Then, inside your project folder, ask: **"Set up this project with Brush Frame."** (or run the `framework-setup` skill).

### Codex

```bash
git clone --depth 1 https://github.com/Alcagoita/brush-frame /tmp/brush-frame \
  && mkdir -p ~/.codex/skills \
  && cp -R /tmp/brush-frame/plugin/skills/framework-setup ~/.codex/skills/ \
  && rm -rf /tmp/brush-frame
```

Restart Codex in your project folder and ask: **"Set up this project with Brush Frame."**

### Any other AI coding tool

Clone this repository and tell your tool: *"Follow `plugin/skills/framework-setup/SKILL.md` to set up this project."*

## What it sets up

| Item | Done by | You |
|---|---|---|
| GitHub repository, `main` + `develop` (default), delete branch after merge | AI | Log in once in the browser |
| Gitflow (task branches, releases, urgent fixes) written into the rule file, so the AI runs it without being asked | AI | Say "merge" or "publish it" when you're ready |
| Merge rules: PR required, checks must pass, no direct pushes, the decider merges | AI | Public repo, or a paid GitHub plan for private ones |
| CI with unit tests (node, python or your own command) | AI | Pick the stack |
| Ticket key on every commit and PR title (local hook + CI check) | AI | — |
| Ticket system: GitHub Issues (labels, templates, practice issue) | AI | — |
| Ticket system: Jira (project, "Won't do", practice ticket) | AI | Create the account. With Claude's Atlassian connector signed in, nothing more; without it, an API token set in your terminal |
| Ticket system: any other board (Trello, Linear, Asana, …) with To do, In development, Testing, Done | AI guides you | Set up the board with the steps it gives you |
| A board with the four columns (To do, In development, Testing, Done) | AI where the tool allows, guided steps where it doesn't | Rename or add a column or two, once |
| AI review with CodeRabbit (config file) | AI | One click to install the app |
| Secrets: `.gitignore` block, secret scanning and push protection | AI | — |
| Rule file: `AGENTS.md`, imported by `CLAUDE.md` — created, or an existing one tidied (status copies, duplicates and stale rules proposed for removal, size before/after) | AI interviews you | Answer four questions, approve each change |
| Memory rules: where corrections, decisions and personal preferences go | AI | — |
| Skills for what you build (web, mobile, backend): up to four suggestions | AI suggests | Pick the ones you want |
| Beta platform (apps, optional) | AI guides | Log in, store accounts are yours |
| Measurement platform (teams, optional) | AI explains | Account and connections are yours |
| Practice ticket through the whole loop | AI | Say "merge" |
| `SETUP_REPORT.md` with the checklist ticked | AI | — |
| The first idea, into a ticket and a brainstorm or design chat | AI | Tell it the idea, pick one |

## Never built software before?

The first thing the helper asks is **"Have you built software before?"** Say *not yet* or *a little* and it changes how it talks, not what it sets up:

- one question at a time, and it makes the technical choices for you from what you're building, telling you each one in a line;
- every technical word gets a plain meaning the first time (a *branch* is a copy where a change waits for your OK; a *pull request* is the page where you look at a change before it goes in);
- it runs each command with you and says what it does first;
- the practice change is told as a short story, and nothing goes in until you say *merge*.

Before anything is built, the helper walks you through what only you can do, step by step for your computer (Mac, Windows or Linux): creating a free GitHub account, a folder for your project (it makes one if you didn't open one), installing Git and GitHub's `gh` tool from their normal installers, and logging in to GitHub in the browser. It then sets your name on your work and lets Git publish to GitHub with that login, using GitHub's private email so yours isn't shown.

You still need a subscription to your AI tool.

## Then, the first idea

The setup questions start with **"What are you building?"** — a web app, a mobile app, both, a backend, something else — so the stack, the tests and the suggestions fit.

**No name yet?** The helper asks *"Do you already have a name, or shall we find one after you tell me the idea?"*, suggests a few, and takes a quick look at whether they're taken (not a legal check).

When the frame is up:

1. **"What's the idea? Say it the way you'd tell a friend."** It goes straight into a decision ticket, so it's safe.
2. **"Want to see it as a quick mockup?"** A first look at one to three screens opens in your browser, in a calm, simple style unless you describe your own. Then: *"Is it something like this you had in mind?"* What you say goes into the ticket.
3. **A few skills that could help** with what you're building, for example Expo and React Native best practices for a mobile app. You pick; nothing is installed without a yes.
4. **The rule file.** No `CLAUDE.md` yet: a short interview writes one. One already there: "Shall I tidy it and add what's missing, or leave it and start a separate one?"
5. **"Want to talk it through first, or start sketching?"**
   - *Talk it through* opens a new chat (Claude or ChatGPT) already started: a practical look at the idea, then a brand expert and a UX designer, then questions for you. You decide.
   - *Start sketching* opens a new chat with one simple question to begin the design.
   - Or *not now*: the idea waits in its ticket.

The prompt is also copied to your clipboard, in case the chat opens empty.

## Optional: Pigment, to see what the work costs

During setup you're asked once whether you want **Pigment**, a separate tool that shows what each prompt, task and session costs beside the chat, and for a team, the sprint by task and who is working now. **Nothing in the framework needs it.** Say no and it's never mentioned again.

If you say yes, it asks where to keep the numbers: in your cloud (needed for a team; Cloudflare's free plan, set up for you after you log in) or just on this computer (a file in the project, kept out of git). More: https://github.com/Alcagoita/pigment

## Joining a project that's already set up

Someone (often the manager) ran the setup; you're joining as a developer:

1. Clone the repository and open it in Claude Code or Codex with the setup kit installed.
2. Ask: **"Set up this project with Brush Frame."** It sees the project is already set up and only does what's personal to your computer: the commit hook, your logins, the recommended skills.
3. If the project uses Pigment with the team's cloud, ask whoever set it up for the **team key** and add it in `/config` under Pigment, with your name.

Then pick a ticket and start the build loop.

## What it never does

- See a password, token or key. Tokens stay in your terminal; the AI never asks for them in chat.
- Pay for anything, accept terms or create accounts for you.
- Force-push, push straight to `main`/`develop` after the rules are on, or delete anything.
- Change anything before showing you the plan (every script runs with `--dry-run` first).

## Anonymous count

At the end, the setup asks whether it may send one anonymous "+1" so the author knows the kit is used. It sends no data about you or your project. Saying no sends nothing. Details: [counter/README.md](counter/README.md).

## Licence

The setup kit (`plugin/`) is CC0: use and change it freely.
