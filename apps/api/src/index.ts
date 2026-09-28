import { serve } from '@hono/node-server'
import { app } from './app.js'

serve({
  fetch: app.fetch,
  port: 8787
}, (info) => { console.log(
  `StoreFlow API is listening on http://localhost:${info.port}`
)})
