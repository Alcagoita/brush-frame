// Run: node counter/test.mjs  — exercises the handler with an in-memory stand-in for D1.
import assert from "node:assert/strict";
import { handle } from "./src/index.js";

const store = new Map();
const env = {
  DB: {
    prepare(sql) {
      return {
        bind(name) {
          return {
            async run() { store.set(name, (store.get(name) || 0) + 1); },
            async first() { return store.has(name) ? { n: store.get(name) } : null; },
          };
        },
      };
    },
  },
};
const req = (method, path) => new Request("https://counter.test" + path, { method, headers: { "x-forwarded-for": "1.2.3.4" }, body: method === "POST" ? "ignored" : undefined });

assert.deepEqual(await (await handle(req("GET", "/v1/count"), env)).json(), { setups: 0 });
assert.equal((await handle(req("POST", "/v1/setup"), env)).status, 204);
assert.equal((await handle(req("POST", "/v1/setup"), env)).status, 204);
assert.deepEqual(await (await handle(req("GET", "/v1/count"), env)).json(), { setups: 2 });
const badge = await (await handle(req("GET", "/v1/badge"), env)).json();
assert.equal(badge.message, "2");
assert.equal((await handle(req("GET", "/v1/setup"), env)).status, 404);
assert.equal((await handle(req("DELETE", "/v1/count"), env)).status, 404);
assert.deepEqual([...store.keys()], ["setup"], "only the counter name is ever stored");
console.log("counter tests passed");
