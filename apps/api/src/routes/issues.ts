import { Hono } from "hono";
import type { AppEnv } from "../types.js";
import { pool } from "../lib/db.js";
import { ApiError } from "../lib/errors.js";
import { validate } from "../lib/validate.js";
import { CreateIssueSchema, IssueIdParam, ListIssuesQuery } from "../schemas/issue.js";

const STORE_ID = 'store-001'
const COLUMNS = `
  id, store_id AS "storeId", 
  title, type, priority, status, assignee_id AS "assigneeId", 
  created_at as "createdAt", updated_at AS "updatedAt"`

export const issueRoutes = new Hono<AppEnv>()

issueRoutes.get('/', 
  validate('query', ListIssuesQuery), async (c) => {
    const { status, type } = c.req.valid('query')
    const { rows } = await pool.query(`
      SELECT ${COLUMNS} FROM issues
      WHERE store_id $1 AND
      ($2::text IS NULL OR status = $2) AND
      ($3::text IS NULL OR type = $3)
      ORDER BY created_at DESC LIMIT 100`,
      [STORE_ID, status ?? null, type ?? null]
    )
    return c.json({ items: rows })
  }
)
issueRoutes.get('/:id',
  validate('param', IssueIdParam), async (c) => {
    const { id } = c.req.valid('param')
    const { rows } = await pool.query(`
      SELECT ${COLUMNS} 
      FROM issues
      WHERE id = $1`, [id]
    )
    if (rows.length === 0) 
      throw new ApiError(404, 
      'NOT_FOUND', 
      `Issue ${id} not found`)
    return c.json(rows[0])
  }
)
issueRoutes.post('/', 
  validate('json', CreateIssueSchema), async (c) => {
    const input = c.req.valid('json')
    const { rows } = await pool.query(`
      INSERT INTO issues (store_id, title, type, priority)
      VALUES ($1, $2, $3, $4)
      RETURNING ${COLUMNS}`,
      [STORE_ID, input.title, input.type, input.priority]
    )
    return c.json(rows[0], 201)
  }
)
