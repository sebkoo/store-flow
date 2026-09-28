import { createServer } from 'node:http'
import { randomUUID } from 'node:crypto'

const issues = []

function sendJson(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json' })
  res.end(JSON.stringify(body))
}

async function readJson(req) {
  let text = ''
  for await (const chunk of req) text += chunk

  return JSON.parse(text)
}

const server = createServer(async (req, res) => {

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
    } else if (req.url === '/issues') {
      let body
      try {
        body = await readJson(req)
      } catch (err) {
        return sendJson(res, 400, { error: { 
          code: 'BAD_JSON', 
          message: `Body is not valid JSON: ${err.message}` } 
        })
      }
      if (typeof body.title !== 'string' || 
                 body.title.trim().length < 3
      ) {
        return sendJson(res, 400, { error: { 
          code: 'VALIDATION_FAILED', 
          message: 'title must be at least 3 characters' } 
        })
      }
      const issue = { 
        id: randomUUID(), 
        title: body.title.trim(), 
        status: 'OPEN', 
        createdAt: new Date().toISOString() 
      }
      issues.push(issue)
      return sendJson(res, 201, issue)
    }
  }
  if (req.method === 'POST' && 
      req.url === '/issues') {
    let body
    try {
      body = await readJson(req)
    } catch (err) {
      return sendJson(res, 400, { error: { 
        code: 'BAD_JSON', 
        message: `Body is not valid JSON: ${err.message}`
        }
      }
    )}
    if (typeof body.title !== 'string' ||
        body.title.trim().length < 3
    ) {
      return sendJson(res, 400, { error: { 
        code: 'VALIDATION_FAILED', 
        message: 'title must be at least 3 characters'
        }
      }
    )}
    const issue = { 
      id: randomUUID(), 
      title: body.title.trim(), 
      status: 'OPEN', 
      createdAt: new Date().toISOString() 
    }
    issues.push(issue)
    return sendJson(res, 201, issue)
  }
  if (req.method === 'GET' && 
      req.url.startsWith('/issues/')
  ) {
    const id = req.url.slice('/issues/'.length)
    const issue = issues.find((i) => i.id === id)
    if (!issue) return sendJson(res, 404, { error: { 
      code: 'NOT_FOUND', 
      message: `Issue ${id} not found` } 
    })
    return sendJson(res, 200, issue)
  }
  sendJson(res, 404, { error: { 
    code: 'NOT_FOUND',
    message: `No route for ${req.method} ${req.url}`
  }})
})

server.listen(8787, () => 
  console.log('Listening on http://localhost:8787')
)