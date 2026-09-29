import { describe, expect, it } from 'vitest'
import { app } from './app.js'

const post = (body: unknown) =>
  app.request('/v1/issues', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

describe('GET /health', () => {
  it('says the API is ok', async () => {
    const res = await app.request('/health')
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({ 
      status: 'ok', 
      service: 'api' 
    })
  })

  it('returns 404 for unknown routes', async () => {
    const res = await app.request('/nope')
    expect(res.status).toBe(404)
  })
})

describe('POST /v1/issues', () => {
  it('creates an OPEN issue with NORMAL priority by default', async () => {
    const res = await post({ 
      title: ' Scanner broken at register 2 ', 
      type: 'SCANNER_BROKEN' 
    })
    expect(res.status).toBe(201)
    expect(await res.json()).toMatchObject({ 
      title: 'Scanner broken at register 2', 
      status: 'OPEN', 
      priority: 'NORMAL' 
    })
  })
  it('rejects a title shorter than 3 characters', async () => {
    const res = await post({ 
      title: 'no', 
      type: 'OTHER' 
    })
    expect(res.status).toBe(400)
  })
  it('rejects a title containing "test"', async () => {
    const res = await post({
      title: 'Just a TEST issue',
      type: 'OTHER'
    })
    expect(res.status).toBe(400)
  })
  it('answers errors in our shape, with the request id', async () => {
    const res = await post({ 
      title: 'no',
      type: 'OTHER'
    })
    const body = await res.json()
    expect(res.status).toBe(400)
    expect(body.error.code).toBe('VALIDATION_FAILED')
    expect(body.error.details[0].path).toBe('title')
    expect(body.error.requestId).toBe(res.headers.get('X-Request-Id'))
  })
})