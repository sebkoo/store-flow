import { Hono } from "hono";

export const app = new Hono()

app.get('/health', (c) => c.json({
  status: 'ok',
  service: 'api'
}))

app.get('/version', (c) => c.json({
  version: '0.1.0',
}))