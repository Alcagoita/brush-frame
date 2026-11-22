# First steps, per computer

What the person does themselves before the setup can build anything, and how to walk them through it. Read the part for their computer only. Say what each step is for in one line, give the link or the command, and wait until it's done. Check with `scripts/check-tools.sh` after each install.

In Claude Code, the person can run a command themselves by typing `!` and the command, e.g. `! gh auth login --web --git-protocol https`. After installing a tool, they may need to close and reopen Claude Code so it finds it.

## Everyone

1. **A GitHub account** (free): https://github.com/signup. They create it; you never do.
2. **The AI tool and a subscription**: Claude Code (the Claude desktop app, Code tab, or the terminal) or Codex.
3. **A folder for the project.** Nothing to do: if they started the AI tool in their home folder, Desktop or anywhere that isn't a project, the setup makes `~/Projects/<name>` and works there. Afterwards, tell them how to come back to it (the desktop app: choose that folder when starting a session; a terminal: `cd ~/Projects/<name>` then `claude`).

## Mac

1. **Git**: run `xcode-select --install`. A window from Apple asks to install the developer tools; click **Install** and wait (a few minutes). If `git --version` already works, skip it.
2. **GitHub's `gh` tool**: download the Mac installer from https://cli.github.com (the **Download for Mac** button) and open it like any app installer. If `brew --version` works, `brew install gh` is quicker.

## Windows

1. **Git**: download **Git for Windows** from https://git-scm.com/download/win and run it with the default choices. It also installs Git Bash, which Claude Code uses on Windows.
2. **GitHub's `gh` tool**: download the Windows installer from https://cli.github.com, or run `winget install --id GitHub.cli`.

## Linux

1. **Git**: `sudo apt install git` (Debian, Ubuntu) or the system's package manager.
2. **GitHub's `gh` tool**: follow https://github.com/cli/cli/blob/trunk/docs/install_linux.md for their system.

## Logging in to GitHub (every computer)

1. Run `gh auth login --web --git-protocol https`. It shows a one-time code and opens github.com in the browser.
2. Paste the code, click **Authorize**, and come back.
3. Run `scripts/git-identity.sh`: it sets their name and GitHub's private email on commits (only if Git doesn't have them yet) and lets Git push with the same login. Without it, the first commit on a new computer fails with "Please tell me who you are", and the first push can ask for a password GitHub no longer accepts.

For a GitHub Projects board (`files/boards.md`), the login also needs the project permission: `gh auth refresh -s project --hostname github.com`, the same browser step once more.
