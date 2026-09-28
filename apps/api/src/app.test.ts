import { describe, expect, it } from 'vitest'
import { app } from './app.js'

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