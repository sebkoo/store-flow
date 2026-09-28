import { serve } from '@hono/node-server'
import { Hono } from 'hono'

const app = new Hono()

app.get('/health', (c) => c.json({
  status: 'ok',
  service: 'api'
}))

app.get('/version', (c) => c.json({
  version: '0.1.0',
}))

serve({
  fetch: app.fetch,
  port: 8787
}, (info) => {
  console.log(`StoreFlow API is listening on http://localhost:${info.port}`)
})
