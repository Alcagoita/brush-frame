# A place for tasks, with a workflow

Brush Frame needs somewhere tasks live, and a board that moves them through **four columns**:

**To do → In development → Testing → Done**

- **In development**: someone (or the AI) is building it, on its own branch.
- **Testing**: the pull request is open and the change is being checked.
- **Done**: merged.

Every task also needs a **short reference** that commits and pull requests start with, so every change leads back to its reason: `KEY-12` (Jira, Linear, YouTrack) or `#12` (GitHub Issues, Trello card numbers).

## Which one

Say it plainly, then let the person choose:

> "The framework was proven with **Jira**, and Jira is free for up to 10 people. If you'd rather keep everything in one place, **GitHub** has tasks and boards built in, nothing else to sign up for. And if you already use **Trello**, **Linear** or something similar, that works too: all it needs is those four columns."

First-time path: if they have no preference, use GitHub (no new account). If they already use a tool, use theirs.

**No sprints for a first-timer.** Set up a simple board (Kanban: tasks move left to right, no planning cycles). Only on the experienced path, ask "Do you work in sprints?"; a yes means a board with a backlog and sprints (Jira's Scrum template, or the tool's equivalent).

What the setup does for each, and what the person does in the browser when the setup can't, is below. Give the steps one at a time, wait for "done", and check what you can.

## Jira (recommended)

**With a token** (`scripts/jira-setup.sh --create-project`): the project is created for them, a Kanban board. Then the columns, below.

**Without a token** (first-time path, or only the Atlassian connector): the person creates the project:

1. Open their Jira site, then **Projects → Create project**.
2. Choose **Kanban** (or **Scrum**, if they work in sprints), then **team-managed**.
3. Name it, and set the **key** to the one agreed in the setup (e.g. `APP`). **Create**.

**The four columns** (the setup can't change a board's columns; the person does it once, about a minute):

1. Open the project's **Board**.
2. Click the **In Progress** column title and rename it **In development**.
3. Click **+** at the right of the columns, add **Testing**, and drag it between *In development* and *Done*.
4. Check the order: To do, In development, Testing, Done.

Then, with the connector or the token, open the practice ticket. Commits start with `APP-12`.

## GitHub (tasks and a board, no extra account)

The setup does: issues on, labels, templates and the practice issue (`scripts/github-issues-setup.sh`). For the board, after `gh auth refresh -s project`:

- `gh project create --owner @me --title "<project name>"`, then link it to the repository with `gh project link <number> --owner @me --repo <owner/name>`.

The person does, in the browser (the board's view and columns can't be set from the command line):

1. Open the project (the link the setup gives), then **⋯ → Settings → Status**.
2. Rename **Todo** to **To do** and **In Progress** to **In development**, and add **Testing** between it and **Done**.
3. Back on the project, **New view → Board**: the four columns appear.

Commits start with the issue number: `#12`.

## Trello

The person does (the setup has no access to Trello):

1. **Create board**, named after the project.
2. Make four lists: **To do**, **In development**, **Testing**, **Done** (rename the default ones and add the rest).
3. Each card has a number in its link (`/c/…/12-…`). To see it on the card itself, add a card-numbers Power-Up from **Power-Ups** (several free ones exist).

Commits start with the card number: `#12`. The setup uses `--tickets other` with no key.

## Linear

Linear's workflow has most of the columns already. The person does, in **Settings → Teams → <team> → Workflow**:

1. Rename **In Progress** to **In development**.
2. Add a **Testing** status in the *Started* group, after it (or rename **In Review** to **Testing**, if the team has it).
3. Leave *Backlog*, *Todo*, *Done* and *Canceled* as they are.

Commits start with the issue key, e.g. `ENG-12`. The setup uses `--tickets other --key ENG`.

## Anything else (Asana, ClickUp, Notion, Monday, YouTrack, …)

It works if it has the four columns (or statuses) and a short reference per task.

1. Make a board, list or status field with **To do, In development, Testing, Done**.
2. Find the task's reference: a key like `ABC-12` (`--tickets other --key ABC`) or a number like `#12` (`--tickets other`).
3. No reference at all? Number the tasks yourself in their titles (`#1 …`, `#2 …`) and use `#12`.

Write the tool, its link and the reference style in `SETUP_REPORT.md` and `AGENTS.md`, so every session knows where tasks live.
