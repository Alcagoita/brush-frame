# Set up a project in one command

Step 4 of the [framework](FRAMEWORK.md) makes a project safe for AI before the first feature. The setup kit does it for you with your own AI tool. **You only log in, create accounts and click two installs. The AI does the rest.**

## Install

### Claude Code

```
/plugin marketplace add Alcagoita/human-led-ai-framework
/plugin install framework-setup@human-led-ai-framework
```

Then, inside your project folder, ask: **"Set up this project with the framework."** (or run the `framework-setup` skill).

### Codex

```bash
git clone --depth 1 https://github.com/Alcagoita/human-led-ai-framework /tmp/hlaf \
  && mkdir -p ~/.codex/skills \
  && cp -R /tmp/hlaf/plugin/skills/framework-setup ~/.codex/skills/ \
  && rm -rf /tmp/hlaf
```

Restart Codex in your project folder and ask: **"Set up this project with the framework."**

### Any other AI coding tool

Clone this repository and tell your tool: *"Follow `plugin/skills/framework-setup/SKILL.md` to set up this project."*

## What it sets up

| Item | Done by | You |
|---|---|---|
| GitHub repository, `main` + `develop` (default), delete branch after merge | AI | Log in once: `gh auth login` |
| Merge rules: PR required, checks must pass, no direct pushes, the decider merges | AI | Public repo, or a paid GitHub plan for private ones |
| CI with unit tests (node, python or your own command) | AI | Pick the stack |
| Ticket key on every commit and PR title (local hook + CI check) | AI | — |
| Ticket system: GitHub Issues (labels, templates, practice issue) | AI | — |
| Ticket system: Jira (project, "Won't do", practice ticket) | AI | Create the account and an API token, set it in your terminal |
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

## Then, the first idea

The setup questions start with **"What are you building?"** — a web app, a mobile app, both, a backend, something else — so the stack, the tests and the suggestions fit.

When the frame is up:

1. **"What's the idea? Say it the way you'd tell a friend."** It goes straight into a decision ticket, so it's safe.
2. **A few skills that could help** with what you're building, for example Expo and React Native best practices for a mobile app. You pick; nothing is installed without a yes.
3. **The rule file.** No `CLAUDE.md` yet: a short interview writes one. One already there: "Shall I tidy it and add what's missing, or leave it and start a separate one?"
4. **"Want to talk it through first, or start sketching?"**
   - *Talk it through* opens a new chat (Claude or ChatGPT) already started: a practical look at the idea, then a brand expert and a UX designer, then questions for you. You decide.
   - *Start sketching* opens a new chat with one simple question to begin the design.
   - Or *not now*: the idea waits in its ticket.

The prompt is also copied to your clipboard, in case the chat opens empty.

## What it never does

- See a password, token or key. Tokens stay in your terminal; the AI never asks for them in chat.
- Pay for anything, accept terms or create accounts for you.
- Force-push, push straight to `main`/`develop` after the rules are on, or delete anything.
- Change anything before showing you the plan (every script runs with `--dry-run` first).

## Anonymous count

At the end, the setup asks whether it may send one anonymous "+1" so the author knows the kit is used. It sends no data about you or your project. Saying no sends nothing. Details: [counter/README.md](counter/README.md).

## Licence

The setup kit (`plugin/`) is CC0: use and change it freely.
