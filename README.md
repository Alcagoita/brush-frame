<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/hero-dark.svg?v=4">
  <img src="assets/hero-light.svg?v=4" width="100%" alt="Brush Frame: a human-led way to build software with AI. You build the frame; the AI holds the brush.">
</picture>

<p>
  <a href="https://doi.org/10.5281/zenodo.24358099"><img src="https://zenodo.org/badge/DOI/10.5281/zenodo.24358099.svg" alt="DOI"></a>
  <img src="https://img.shields.io/badge/version-0.4-b87524" alt="Version 0.4">
  <img src="https://img.shields.io/badge/text-CC%20BY%204.0-6b675e" alt="Text CC BY 4.0">
  <img src="https://img.shields.io/badge/setup%20kit-Claude%20Code%20%C2%B7%20Codex-e8a86a" alt="Setup kit for Claude Code and Codex">
</p>

**Brush Frame** is a human-led way to build software with AI, for one person with an idea or a whole team. Eight steps take an idea to a release: AI does the analysis, the building and the review, and a person makes every decision that matters. A ticket system holds the memory, so every change leads back to a reason.

**It's proven on a real product.** The [Brush](https://brushaway.app) app (Android, iOS and Wear OS, with its own place API and database) and its website were built with it, by one person holding every role. You don't need the app to use the framework; it's the proof that the framework works.

**Not a developer?** The setup helper handles the technical side and asks you simple questions first. You bring the idea and make the decisions.

- **Read the framework:** [FRAMEWORK.md](FRAMEWORK.md)
- **Copy the templates:** [templates/](templates/)

## Start a project with it

### No prompts to learn

It's not prompting, it's talking. The setup helper asks one question at a time, in plain words, and nothing happens until you say yes:

> *"Have you built software before?"*
> *"What's the idea? Say it the way you'd tell a friend."*
> *"Looks good? Say merge, and it goes in."*

### Install

Brush Frame isn't an app you download. The setup helper runs inside the AI tool you build with: Claude Code or Codex.

**In the Claude desktop app** (Code tab, a local session):

1. Click **+** next to the message box, then **Add plugins** (or **Plugins → Browse plugins**).
2. On the **Marketplaces** tab, add **`Alcagoita/brush-frame`**.
3. On the **Plugins** tab, find **framework-setup** and click **Install**, then **Install for you**.

**In Claude Code in a terminal:**

```
/plugin marketplace add Alcagoita/brush-frame
/plugin install framework-setup@brush-frame
```

**Codex and other tools:** see [SETUP.md](SETUP.md).

Then ask: **"Set up this project with Brush Frame."** No project folder yet? It makes one for you.

### What the helper does

1. Asks **whether you've built software before**. First time? It speaks in plain words, one question at a time, explains each technical word once, runs each step with you, and makes the technical choices from what you're building.
2. Walks you through what only you can do, for your computer (Mac, Windows or Linux): a free GitHub account, Git and GitHub's tool from their normal installers, and one login in the browser.
3. Asks **what you are building**, and the name (or helps you find one, with a quick look at whether it's taken).
4. Shows the plan, runs every script with `--dry-run` first, then sets up: GitHub with `main` and `develop`, merge rules, tests on every change, a task reference on every commit, AI review and secret protection.
5. Sets up a **task board** with **To do, In development, Testing, Done**: Jira is recommended (it's where this was proven, and free), and GitHub, Trello, Linear or any similar tool works. Where it can't build the board itself, it gives you the steps.
6. Writes or tidies the project's rule file (`AGENTS.md`, imported by `CLAUDE.md`), including **Gitflow**: the AI runs task branches, releases and urgent fixes by itself, and you only say *merge* or *publish*.
7. Suggests a few skills for what you build (nothing is installed without a yes), and asks whether you want **Pigment** (below): recommended for a team, offered when it's just you.
8. Runs a practice change through the whole loop, told as a short story. You say *merge*.
9. Asks for your idea, saves it in a decision ticket, shows it as a **quick mockup** if you'd like (in a calm, simple style unless you describe your own), then opens a chat to **talk it through** with a brand expert and a UX designer, or to **start sketching**.

**Joining a project that's already set up?** Ask the same thing. It sees the project is set up and only sets up your computer.

It never sees a password, token or key, never pays or accepts terms for you, and never force-pushes or deletes. You still need a subscription to your AI tool. Details: [SETUP.md](SETUP.md).

## Optional: Pigment, what the work costs

[Pigment](https://github.com/Alcagoita/pigment) is a separate Claude Code mod that shows, beside the chat, what each prompt, task and session costs. **Optimize now** writes a summary of the work in progress so you can carry on in a fresh session. For a manager, it shows the sprint by task, who is working now, the time worked on each task, and which tasks are close to their estimate. It can log worked time in Jira when a task reaches Testing.

Numbers stay on your computer (a file in the project, kept out of git) or in your own Cloudflare account, which a team needs. Only numbers are stored, never prompts or code. **The helper always asks first: it recommends it for a team, and offers it when it's just you.** Brush Frame itself works without it.

```
/plugin marketplace add Alcagoita/pigment
/plugin install pigment@pigment
```

## The eight steps

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/steps-dark.svg?v=4">
  <img src="assets/steps-light.svg?v=4" width="100%" alt="The eight steps of Brush Frame as a loop: Idea check, Design, Planning, Setup, Build loop, Field test, Learn, Release. A person decides at the gates after Idea check and Design, and merges every change.">
</picture>

<details>
<summary>The steps as text</summary>

1. **Idea check:** decide whether an idea is worth building.
2. **Design:** screens, model facts and product promises.
3. **Planning:** small tickets with one clear goal each.
4. **Setup:** guardrails before the first feature.
5. **Build loop:** one ticket, one branch, one reviewed PR.
6. **Field test:** real people, real devices.
7. **Learn:** every correction becomes a rule.
8. **Release:** a tagged version with notes.

</details>

## Status

Version 0.4, draft. See the [changelog](CHANGELOG.md). Proposals for changes are welcome as issues, with the reason.

## Author

**Olegário Nascimento**, Tech Lead and Engineering Manager, building software since 2012.

Brush Frame comes from building [Brush](https://brushaway.app) alone with AI, holding every role: an Android and iOS app, a Wear OS companion, its own place API and database, and its website. Its companion, [Pigment](https://github.com/Alcagoita/pigment), shows what that AI work costs.

## How to cite

> Nascimento, O. (2026). *Brush Frame: a human-led way to build software with AI*. Zenodo. https://doi.org/10.5281/zenodo.24358099

This DOI always points to the latest version. Each release also has its own DOI on [Zenodo](https://doi.org/10.5281/zenodo.24358099): v0.4 is [10.5281/zenodo.24449191](https://doi.org/10.5281/zenodo.24449191), v0.3 is [10.5281/zenodo.24407428](https://doi.org/10.5281/zenodo.24407428), v0.2 is [10.5281/zenodo.24358100](https://doi.org/10.5281/zenodo.24358100). GitHub's "Cite this repository" button uses [CITATION.cff](CITATION.cff).

## Licence

The framework text is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Share and adapt it, including commercially, with credit to Olegário Nascimento. The templates in `templates/` are released under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). See [LICENSE](LICENSE).
