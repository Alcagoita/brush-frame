# Setup counter

Counts how many times the framework setup has finished, so the author knows whether people use it. Nothing else.

## What is collected

**Only a number.** When a user agrees at the end of setup, the skill sends one `POST /v1/setup` with no body. The Worker adds 1 to a single row in a database and answers `204`. It does not read the request's body, headers, IP address or user agent, and request logging is switched off. There is no way to know who sent a count or from which project.

Like every website, Cloudflare's network sees the connection while it is open; the Worker does not keep it.

Counting is opt-in: the setup asks first, and a "no" sends nothing.

## Read the number

- `GET /v1/count` → `{"setups": 42}`
- `GET /v1/badge` → a [shields.io endpoint](https://shields.io/badges/endpoint-badge) for the README badge

## Deploy (once, by the owner)

```bash
cd counter
npx wrangler login
npx wrangler d1 create framework-counter      # copy the database_id into wrangler.toml
npx wrangler d1 execute framework-counter --remote --file schema.sql
npx wrangler deploy
```

Then set the deployed URL as `COUNTER_URL` in `plugin/skills/framework-setup/scripts/count-install.sh`.

Test locally with `node counter/test.mjs`.

## Limits

Anyone can send a `POST`, so the number is an honest estimate, not an audit. Re-running setup on the same project counts again.
