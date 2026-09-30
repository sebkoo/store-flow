import { afterAll, describe, expect, it } from 'vitest'
import { app } from './app.js'
import { pool } from './lib/db.js'

const createdIds: string[] = []

afterAll(async () => {
  await pool.query('DELETE FROM issues WHERE id = ANY($1::uuid[])', [createdIds])
  await pool.end()
})

describe('issues in PostgreSQL', () => {
  it('stores an issue and reads it back', async () => {
    const res = await app.request('/v1/issues', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        title: 'Printer out of paper',
        type: 'PRINTER_FAILURE'
      })
    })
    expect(res.status).toBe(201)
    const issue = await res.json()
    createdIds.push(issue.id)

    const again = await app.request(`/v1/issues/${issue.id}`)
    expect(await again.json()).toMatchObject({
      id: issue.id,
      status: 'OPEN',
      priority: 'NORMAL'
    })

    const { rows } = await pool.query(`
      SELECT store_id, status
      FROM issues
      WHERE id = $1`, [issue.id]
    )
    expect(rows[0]).toEqual({
      store_id: 'store-001',
      status: 'OPEN'
    })
  })
  it('answers 400, not 500, for an id that is not a UUID', async () => {
    const res = await app.request('/v1/issues/not-a-uuid')
    expect(res.status).toBe(400)
  })
  it('filters by status', async () => {
    const res = await app.request('/v1/issues?status=RESOLVED')
    const body = await res.json()
    expect(body.items.every((
      i: { status: string }) => i.status === 'RESOLVED'
    )).toBe(true)
  })
})