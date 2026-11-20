# Skills and plugins to suggest, by what the person is building

Suggest **at most four**, the ones that match what they said. One plain line each on what it helps with. Install only the ones they say yes to. Never install a paid service's plugin as if it were needed.

Install lines:
- **Claude Code:** `claude plugin marketplace add <owner/repo>` (once per marketplace), then `claude plugin install <plugin>@<marketplace>`. The official marketplace (`claude-plugins-official`) is already known to Claude Code.
- **Codex:** clone the repository and copy the skill folder into `~/.codex/skills/` (`git clone --depth 1 <repo> /tmp/s && cp -R /tmp/s/<path to skill> ~/.codex/skills/ && rm -rf /tmp/s`). Plugins that are MCP servers or LSPs are Claude Code only; say so instead of offering them in Codex.

If a line below fails (a plugin renamed or moved), say so plainly and skip it; never guess a replacement.

## Mobile app

| Suggest when | Plugin | Claude Code | Codex |
|---|---|---|---|
| React Native with Expo | `expo` — Expo setup, EAS builds, store releases, native UI | `claude plugin install expo@claude-plugins-official` | — |
| Any React Native | `react-native-best-practices` — performance: renders, lists, startup, memory | `claude plugin marketplace add callstackincubator/agent-skills` then `claude plugin install react-native-best-practices@callstack-agent-skills` | copy from `github.com/callstackincubator/agent-skills` |
| React Native, an upgrade ahead | `upgrading-react-native` — version upgrades step by step | same marketplace, `upgrading-react-native@callstack-agent-skills` | same repository |
| Native iOS (Swift) | `swift-lsp` — code intelligence for Swift | `claude plugin install swift-lsp@claude-plugins-official` | — |
| Native Android (Kotlin) | `kotlin-lsp` — code intelligence for Kotlin | `claude plugin install kotlin-lsp@claude-plugins-official` | — |

## Web app

| Suggest when | Plugin | Claude Code | Codex |
|---|---|---|---|
| Any web interface | `frontend-design` — interfaces that don't look generic | `claude plugin install frontend-design@claude-plugins-official` | — |
| Deploying on Vercel / Next.js | `vercel` — deploys, previews, Next.js | `claude plugin install vercel@claude-plugins-official` | — |
| They want browser tests | `playwright` — drive a real browser to test | `claude plugin install playwright@claude-plugins-official` | — |
| Designs live in Figma | `figma` — read designs into code | `claude plugin install figma@claude-plugins-official` | — |

## Backend, API, data

| Suggest when | Plugin | Claude Code | Codex |
|---|---|---|---|
| Cloudflare Workers, D1, R2 | `cloudflare` — Workers, Wrangler, Durable Objects | `claude plugin marketplace add cloudflare/skills` then `claude plugin install cloudflare@cloudflare` | copy from `github.com/cloudflare/skills` |
| Firebase (auth, Firestore, hosting, app testing) | `firebase` — projects, Firestore, auth, App Distribution | `claude plugin marketplace add firebase/skills` then `claude plugin install firebase@firebase` | copy from `github.com/firebase/skills` |
| Supabase | `supabase` — database, auth, edge functions | `claude plugin install supabase@claude-plugins-official` | — |
| Payments with Stripe | `stripe` | `claude plugin install stripe@claude-plugins-official` | — |

## Any project

| Suggest when | Plugin | Claude Code | Codex |
|---|---|---|---|
| Always worth a mention | `code-review` — a review pass before the PR, beside AI review | `claude plugin install code-review@claude-plugins-official` | — |
| Always worth a mention | `pigment` — what each prompt, task, session and sprint costs, beside the chat; a calm nudge to start fresh when a conversation gets long | `claude plugin marketplace add Alcagoita/pigment` then `claude plugin install pigment@pigment` | — |
| Handles personal data or payments | `security-guidance` — security checks while writing code | `claude plugin install security-guidance@claude-plugins-official` | — |
| Already uses Sentry | `sentry` — read errors and issues | `claude plugin install sentry@claude-plugins-official` | — |
