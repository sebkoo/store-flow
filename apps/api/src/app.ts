import { Hono } from "hono";
import { requestId } from "hono/request-id";
import type { AppEnv } from "./types.js";
import { handleError } from "./lib/errors.js";
import { log } from "node:console";
import { issueRoutes } from "./routes/issues.js";

export const app = new Hono<AppEnv>()

app.use(requestId())

app.use(async (c, next) => {
  const started = performance.now()
  await next()
  log('info', 'request', {
    requestId: c.get('requestId'),
    method: c.req.method,
    path: c.req.path,
    status: c.res.status,
    ms: Math.round(performance.now() - started)
  })
})
app.onError(handleError)
app.notFound((c) => c.json({ error: {
  code: 'NOT_FOUND',
  message: `No route for ${c.req.method} ${c.req.path}`,
  requestId: c.get('requestId')
  }}, 404)
)

app.get('/health', (c) => c.json({
  status: 'ok',
  service: 'api'
}))
app.get('/version', (c) => c.json({
  version: '0.1.0',
}))
app.route('/v1/issues', issueRoutes)