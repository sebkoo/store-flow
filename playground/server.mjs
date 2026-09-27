import { createServer } from 'node:http'

function sendJson(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json' })
  res.end(JSON.stringify(body))
}

const server = createServer((req, res) => {
  console.log(`${req.method} ${req.url}`)
  if (req.method === 'GET') {
    if (req.url === '/version') {
      return sendJson(res, 200, {
        version: '0.1.0'
      })
    } else if (req.url === '/health') {
    return sendJson(res, 200, { 
      status: 'ok', 
      service: 'playground',
      version: '0.1.0', 
    })
  }}
  sendJson(res, 404, {
    error: { 
      code: 'NOT_FOUND', 
      message: `No route for ${req.method} ${req.url}` 
    },
  })
})

server.listen(8787, () => console.log('Listening on http://localhost:8787'))