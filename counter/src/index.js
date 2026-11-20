// Anonymous setup counter for the framework.
// Stores one number per counter name. Reads nothing from the request: no body, no headers,
// no IP, no user agent. Nothing is logged (observability is off in wrangler.toml).
//
//   POST /v1/setup   -> +1, answers 204
//   GET  /v1/count   -> {"setups": n}
//   GET  /v1/badge   -> shields.io endpoint JSON, for a README badge

const COUNTER = "setup";

export async function handle(request, env) {
  const url = new URL(request.url);
  const cors = { "Access-Control-Allow-Origin": "*" };

  if (request.method === "POST" && url.pathname === "/v1/setup") {
    await env.DB.prepare(
      "INSERT INTO counts (name, n) VALUES (?1, 1) ON CONFLICT(name) DO UPDATE SET n = n + 1"
    ).bind(COUNTER).run();
    return new Response(null, { status: 204, headers: cors });
  }

  if (request.method === "GET" && (url.pathname === "/v1/count" || url.pathname === "/v1/badge")) {
    const row = await env.DB.prepare("SELECT n FROM counts WHERE name = ?1").bind(COUNTER).first();
    const n = row ? row.n : 0;
    const body = url.pathname === "/v1/count"
      ? { setups: n }
      : { schemaVersion: 1, label: "setups", message: String(n), color: "c1802e" };
    return Response.json(body, { headers: { ...cors, "Cache-Control": "public, max-age=300" } });
  }

  return new Response("Not found", { status: 404, headers: cors });
}

export default { fetch: handle };
