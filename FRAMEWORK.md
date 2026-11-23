# Brush Frame

*A human-led way to build software with AI.* You build the frame; the AI holds the brush.

By Olegário Nascimento · Version 0.4, draft · 2026-11-22 · DOI [10.5281/zenodo.24358099](https://doi.org/10.5281/zenodo.24358099). Changes are listed in the [changelog](#changelog) at the end.

A step-by-step way to build software with AI where people stay in charge. It works for one person holding every role, or a team with one person per step. Each step says why it exists, who does it, what goes in, what comes out, and when it is done.

The templates referenced below are in [`templates/`](templates/).

## How it works

### Principles

1. **People decide, AI makes them faster.** People own decisions, merges and real-world testing. AI analyses, builds and reviews inside written rules.
2. **The ticket system is the memory.** No work without a ticket. Every change leads back to a reason, and every decision stays findable.
3. **Small tickets, one clear goal each.** AI does its best work on small, well-defined tasks.
4. **Guardrails from day one.** Tests, merge rules, AI review and a rule file exist before the first feature.
5. **Build to learn, then replace.** An MVP may take shortcuts, as long as each one is marked temporary.
6. **Real people test what personas can't.** AI personas shape ideas; testers on real devices decide what stays.
7. **A product keeps its promises.** Every product needs one main idea and a few promises that make it unique, such as "what we show is always real" or "the app does the work, so the user can relax". Every step respects them, including how the product makes money: a business model that breaks a promise is the wrong model.
8. **Open mind, never blind trust.** The decider listens to every idea and rejects none without a reason, but never accepts an AI answer just because it looks good.

### The steps at a glance

| Step | Runs | Produces |
| --- | --- | --- |
| 1. Idea check | Per idea | A decision ticket |
| 2. Design | Per idea that passes | Design files and model facts |
| 3. Planning | Per cycle | A backlog of small tickets |
| 4. Setup | Once per project | A repo the AI can work in safely |
| 5. Build loop | Per ticket | One merged PR |
| 6. Field test | Continuously | Feedback and bug tickets |
| 7. Learn | Per correction | A rule in the rule file |
| 8. Release | Per cycle | A tagged version with notes |

Steps 5 to 7 repeat for every ticket. Field-test feedback goes back to step 1 (new idea) or step 3 (new ticket).

### Gates

Two moves need an explicit OK from the decider: the product manager in a team, the owner when solo. The AI and the personas advise; a person decides. Each OK is written in the decision ticket.

| Gate | From | To |
| --- | --- | --- |
| The idea is worth building | 1. Idea check | 2. Design |
| The design is ready to become tickets | 2. Design | 3. Planning |

A third rule holds everywhere: nothing merges without the decider's word.

### The decider

The method depends on how the decider works, more than on any tool.

- **No dogmas.** A rule stays because its reason still holds, not because it was written down. If the reason is gone, the rule goes.
- **No fighting ideas without a reason.** An idea that clashes with the plan gets an idea check, not a reflex no.
- **No blind acceptance.** An AI answer that looks good is a proposal. Ask why, check it against the ticket and the product promises, then decide.
- **Guard the promises.** When a change would break a product promise, it needs a decision ticket, however small the change looks.

### When it fits

It fits when:

- The product is meant to last and grow, not to be thrown away.
- Someone can decide: the owner when solo, the product manager in a team.
- The work can be split into small tickets with one goal each.
- Real people can try the builds.

It does not fit when:

- The work is a throwaway prototype or a hackathon. The setup costs more than the code is worth.
- No one has the final word. Gates stall, or the AI's answer wins by default.
- The goal is still unknown. Run it as one exploration ticket first, then plan from what it found.

### Costs

The framework trades speed at the start for safety later. Its known costs:

- **Setup comes first.** Step 4 takes time before any feature ships.
- **The decider is a bottleneck, by design.** Work waits for their OK, and an absent decider stops the flow.
- **More tickets.** Small tickets mean more to write, order and close.
- **Rule files need care.** Without a review at each release they go stale, and the AI follows old rules.
- **Tools cost money.** AI tools, AI review, the ticket system, the beta and measurement platforms. The bill grows with the team. Before there is revenue, keep the list short and review it at each release.
- **Discipline over habit.** Skipping the ticket "just this once" is how the memory breaks.
- **Real-world testing takes people and time.** It cannot be automated away.

### Pace

This way of working needs a lot of thinking ahead, and that can be tiring. Without the thinking, it becomes vibe coding.

- **Set working hours and keep them.** Burnout costs more than any feature.
- **Stuck? Drop it and come back later.** A parked ticket is not a failure.
- **Don't overthink.** A good-enough ticket that ships beats a perfect one that waits.

### Roles

| Role | Solo | Team | Owns |
| --- | --- | --- | --- |
| Decider | The owner | Product manager | Gates, merges, product promises |
| UX and brand | The owner with AI personas | UX designer, brand expert | Step 2, persona input in step 1 |
| Tech lead | The owner | Tech lead | Setup, releases, hotfixes |
| Developer | The owner with AI | Each developer with their own AI | The build loop |
| Testers | Beta testers | Beta testers and QA | Field test |
| Rule owner | The owner | The owner of each rule area | Step 7 |
| AI | Builds, reviews, plays personas | The same | Advice only, never decisions |

## Step 1 — Idea check

**Why:** decide whether an idea is worth building before anyone designs or codes it.

**Who:** solo, the owner with AI personas. Team: the product manager, with UX and brand.

**Input:** the idea, written as one short paragraph.

**How:**

1. Ask the AI for a practical analysis: can it be built, what it costs, what could go wrong, what already exists.
2. If it survives, run a persona discussion (for example a brand expert and a UX designer). See the [persona brief](templates/persona-brief.md).
3. Check the idea against the product promises. The decider chooses: go, park or drop.
4. Write the outcome in a decision ticket the same day. Chat history and tool sessions can be lost; the ticket cannot.

**Output:** a [decision ticket](templates/decision-ticket.md). Parked and dropped ideas keep their reason, so they can be found later.

**Done when:** the decider has given the OK, or the idea is closed as "Won't do" with its reason.

## Step 2 — Design

**Why:** turn the idea into screens and the few rules everything else depends on.

**Who:** solo, the owner. Team: the UX designer.

**Input:** the decision ticket from step 1.

**How:**

1. Design the main screens and the design tokens (colours, type, spacing) with an AI design tool.
2. Write the **model facts**: the handful of rules the product stands on, such as what a task is or when data is collected. These are what later tickets must not break. On the first idea, also write the product promises: the main idea and the few rules that make the product unique.
3. Export the results into the repo the same day, for example under `docs/design/`.

**Output:** design files and model facts in the repo, linked from the decision ticket.

**Done when:** the decider gives the OK that the design is ready to become tickets (gate 2).

## Step 3 — Planning

**Why:** cut the design into work an AI can do well, and that leaves a trace.

**Who:** solo, the owner. Team: the product manager.

**Input:** design files and model facts.

**How:**

1. **Define 1.0 first:** the features the first public version needs. Ideas beyond it are parked for later versions, each with a ticket.
2. Group the work into epics, one per feature area.
3. Split each epic into small tickets with one clear goal each ([work ticket](templates/work-ticket.md)).
4. Mark any MVP shortcut as temporary, with the condition for replacing it.
5. Pick the tickets for the next cycle and put them in order.

**Output:** a backlog, and a cycle with its tickets in order.

**Done when:** every ticket in the cycle has one goal, a way to check it is done, and is small enough for one branch.

## Step 4 — Setup (once per project)

**Why:** make the project safe for AI to work in from the first ticket, instead of adding guardrails after something breaks.

**Who:** solo, the owner. Team: the tech lead.

**Input:** the first planned cycle.

**How:**

- [ ] **Ticket system:** statuses for to do, in progress, in review, done, plus a "Won't do" resolution that needs a reason.
- [ ] **Branching model:** for example Gitflow. Feature branches named after their ticket key, cut from and merged back to the integration branch.
- [ ] **Commit format:** every commit starts with a ticket key, setup and spikes included.
- [ ] **Merge rules:** a PR is required, checks must pass, and only the decider merges.
- [ ] **Unit tests** running on every PR.
- [ ] **AI review** on every PR.
- [ ] **A rule file for the AI tool the project uses** (CLAUDE.md for Claude, AGENTS.md for Codex), started from the [starter rule file](templates/starter-rule-file.md). One file is enough. If people use both tools, keep the rules in `AGENTS.md` and have `CLAUDE.md` import it. If one already exists, tidy it instead of replacing it: keep what's there, add what's missing, and remove status copies, rules said twice and rules whose reason is gone. Versioned, privately if needed.
- [ ] **Memory rules:** say where things go, so every tool files them the same way. Corrections for everyone become rules in the rule file; decisions go in tickets; personal preferences stay in each person's own tool memory; ticket status, keys and tokens go nowhere.
- [ ] **Skills for what you build:** a few AI skills or plugins that fit the platform (web, mobile, backend), chosen by the person, never installed by default.
- [ ] **A beta platform:** a way to send test builds to testers before any store release, and to collect their crashes and reports. Firebase is one option; app stores also offer their own testing channels.
- [ ] **Team only — a measurement platform:** a tool that shows how the team works with AI, such as how AI is used across tickets, cycle time and rework, instead of ranking individuals by output. [Span](https://www.span.app/) is one example.
- [ ] **Optional — a cost view:** what each prompt, task and sprint costs, for anyone who wants to see it. Never required. [Pigment](https://github.com/Alcagoita/pigment) is one option.
- [ ] **Secrets and access:** keys live in local files outside the repo, never in prompts, chat or rule files. AI tools run with the least access the work needs. Decide what code and notes may be public, and keep the rest private.

**Output:** a repo and ticket system ready for the build loop.

**Done when:** one practice ticket has gone through the whole build loop without a manual workaround.

### Joining a project

Setup runs once per project, usually by whoever owns it. Someone joining later only sets up their own computer:

1. Clone the repository and read the rule file (`CLAUDE.md` or `AGENTS.md`) and the setup report.
2. Turn on the commit hook for the clone (`git config core.hooksPath .githooks`) and log in to the tools the project uses: GitHub, the ticket system.
3. Install the skills the setup report recommends, if they help.
4. If the project shares a cost view or another team tool, ask the setup owner for the access key; keys are passed privately, never through the repository.
5. Take a first ticket through the build loop.

## Step 5 — Build loop (per ticket)

**Why:** the same short loop for every change, so each one is traceable and reviewed.

**Who:** solo, the owner and the AI, one ticket at a time. Team: each developer with their own AI, one ticket each.

**Input:** one ticket from the current cycle.

**How:**

1. Check the ticket's real status in the ticket system, never a copy elsewhere.
2. Move it to in progress and cut a branch named after it.
3. The AI builds it, with unit tests for any logic. The ticket is the spec: nothing outside it.
4. For jobs over a lot of data, run on a small sample first, check, then widen.
5. Open a PR and move the ticket to in review.
6. AI review runs; fixes are committed and pushed straight away, so the PR always shows the current state.
7. The decider says merge. Merge, then close the ticket.
8. Only then start the next ticket.

**Output:** one merged PR and one closed ticket.

**Done when:** the PR is merged into the integration branch and the ticket is closed.

### When something breaks

- **The person diagnoses first.** Find the problem, or narrow it down as far as you can, before handing it to the AI. A vague bug sends the AI on a hunt; a specific one gets fixed.
- **Experience counts here.** This is where a developer with a good idea differs from someone with only a good idea.
- **Don't retry what failed.** Compare against a version that works and find the difference.
- **Root cause first,** then the fix, then the tests that lock it in.

### AI sessions

- One session per cycle keeps that cycle's context in one place.
- When a session gets too long, ask the AI for a summary and start a new session from it.
- Anything that must outlive the session goes in a ticket or a rule file (step 7).

## Step 6 — Field test

**Why:** some things only show up in real use, on a real device, in the real world. AI review and unit tests cannot replace this.

**Who:** beta testers, solo or team. In a team, QA too.

**Input:** a build from the integration branch, sent to testers through the beta platform (step 4).

**How:**

1. Testers use the app as they normally would, on their own devices.
2. Every report becomes a ticket, tagged with where it came from ([feedback ticket](templates/feedback-ticket.md)).
3. Bugs go to the next cycle (step 3). Bigger changes go back to the idea check (step 1).
4. From time to time, compare the bugs testers find with what AI review caught. It shows what the review misses.

**Output:** feedback and bug tickets, tagged by source.

**Done when:** every report has a ticket. This step never closes; it runs alongside the others.

## Step 7 — Learn: corrections become rules

**Why:** every time a person has to correct the AI, that correction should only ever be needed once.

**Who:** solo, the owner. Team: the owner of that rule area.

**Input:** a correction: the AI did something it should not have, or missed something it should have known.

**How:**

1. Write the rule: what to do, why, the ticket where it happened, and a review date ([rule entry](templates/rule-entry.md)).
2. Add it to the rule file of every AI tool the project uses, so they stay in step.
3. Decisions go in tickets and rule files, never only in chat, where the next session cannot see them.
4. At each release, read the rule files and remove rules that are stale or no longer true.

**Output:** an updated rule file.

**Done when:** the correction is in every rule file, with its source.

## Step 8 — Release

**Why:** close a cycle with a version people can use and notes that say what changed.

**Who:** solo, the owner. Team: the tech lead.

**Input:** a cycle whose tickets are all merged.

**How:**

1. Check the release has not already been done: look at the tags and the version.
2. Cut a release branch, bump the version and merge it into the production branch. Before a store release, the build goes to testers through the beta platform first.
3. **First public release:** check each store's rules early, such as tester numbers, fees, privacy policy and data attribution. On a tight budget, start on the store that is cheaper to enter, prove the product there, then add the next. Build for every platform from the start, so adding one is a release, not a rewrite.
4. Tag the release and publish notes, grouped by feature area.
5. Merge back into the integration branch.
6. Review the rule files (step 7) and plan the next cycle (step 3). In a team, also review the cycle's numbers on the measurement platform: they judge how the team uses AI, not one person's output.
7. Review tool costs against the budget. Keep only the tools that earn their cost.

**Output:** a tagged version and its release notes.

**Done when:** the tag and notes are published and the next cycle is planned.

### Hotfix

An urgent bug in production does not wait for the cycle.

1. Open a ticket for it.
2. Cut a hotfix branch from the production branch.
3. Run the build loop (step 5) on it: tests, AI review, the decider's word.
4. Merge into the production branch and the integration branch, then tag a patch version.

## Big technical changes

A service that becomes too expensive or too limiting is an idea like any other: it goes through the idea check (step 1).

- The decision ticket records the cost, the terms or licence, what moves, and how to go back.
- Each part goes where it fits best. One service can keep the user accounts while another serves the data.
- Move in steps. The old path stays until the new one works.
- A website that presents the product is its own track, planned with its own tickets. It tells people about the product; it does not run it.

## Pitfalls

- **Vibe coding:** building without tickets, a plan or gates.
- **Decisions left in chat:** the next session cannot see them.
- **Big tickets:** the AI drifts and the review cannot keep up.
- **Status copied into rule files:** it goes stale and misleads the AI. The ticket system holds status.
- **Running a job over all the data first:** a small sample finds the mistakes cheaply.
- **Accepting an AI answer because it reads well.**
- **Starting the next ticket before the current one is merged.**
- **Sending the AI to hunt a bug without a diagnosis.**
- **Making money in a way that breaks a product promise.**

## A worked example

A made-up plant-watering app wants to let people share a plant with a housemate.

1. **Idea check:** the owner writes one paragraph. The AI's analysis says it can be built but needs a link between accounts. The UX persona warns that both people could be reminded at once. The product promise is "never nag", so the idea passes on one condition: only one person is reminded. The decider says go, and it goes in a decision ticket.
2. **Design:** two screens, invite and accept. New model fact: a plant has one owner, and a shared plant has helpers. The decider gives the OK.
3. **Planning:** an epic, Sharing, with four tickets: invite link, accept screen, helper reminders, remove a helper.
4. **Setup:** already done for this project.
5. **Build loop:** the invite-link ticket gets a branch. The AI builds it with tests. AI review flags expired links; the fix is pushed. The decider says merge.
6. **Field test:** a tester reports that both people got the reminder. It becomes a feedback ticket for the next cycle.
7. **Learn:** the AI had added a new notification without asking. New rule: no new notification without a decision ticket.
8. **Release:** version 1.3.0 ships, with notes under Sharing.

## Adopting it

**Setup in one command:** the setup kit does step 4 from Claude Code or Codex, then asks for the first idea and opens a brainstorm or a design for it. The person only logs in and clicks two installs. See [SETUP.md](SETUP.md).

Start small and add the rest as the project grows.

1. **Day one:** the ticket system, branch and merge rules, unit tests and one rule file. Run the build loop (step 5) with these alone.
2. **Before the first testers:** add AI review and the beta platform, and start field tests (step 6).
3. **Once corrections repeat:** make step 7 a habit and review the rule files at each release.
4. **When a second person joins:** give each step an owner and add the measurement platform.

**An existing project** starts at step 4 with what it already has. Write the model facts and product promises from the product as it is, and open tickets for work in progress. Old history does not need to be backfilled.

## Glossary

- **Decider:** the person with the final word. The owner when solo, the product manager in a team.
- **Gate:** a move that needs the decider's explicit OK, written in the decision ticket.
- **Decision ticket:** the record of an idea check: go, park or drop, and why.
- **Model fact:** a rule the product stands on, which later tickets must not break.
- **Product promise:** the main idea and the few rules that make the product unique.
- **Persona:** an AI given a role, such as a brand expert, to discuss an idea. It advises; it never decides.
- **Rule file:** the written instructions an AI tool reads at the start of each session.
- **Cycle:** a planned set of tickets that ends in a release.
- **MVP shortcut:** a temporary choice, marked with the condition for replacing it.
- **Integration branch:** the branch every feature merges into before a release.

## Changing this framework

- Anyone using it can propose a change as an issue, with the reason.
- The decider approves or rejects it.
- Every approved change bumps the version and gets a changelog line.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Licence

This framework is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You may share and adapt it, including for commercial use, with credit to Olegário Nascimento. The templates are released under [CC0](https://creativecommons.org/publicdomain/zero/1.0/): copy them freely, no credit needed.
