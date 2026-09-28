import { Hono } from "hono";
import { issueRoutes } from "./routes/issues.js";

export const app = new Hono()

app.get('/health', (c) => c.json({
  status: 'ok',
  service: 'api'
}))
app.get('/version', (c) => c.json({
  version: '0.1.0',
}))
app.route('/v1/issues', issueRoutes)