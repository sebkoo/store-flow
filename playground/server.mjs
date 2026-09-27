import { createServer } from 'node:http'

const server = createServer((req, res) => {
  console.log(`${req.method} ${req.url}`)
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' })

  if (req.url === '/ping') return res.end('pong\n')
  res.end('StoreFlow server is alive\n')
})

server.listen(8787, () => {
  console.log('Listening on http:localhost:8787')
})