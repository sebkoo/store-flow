import { Hono } from "hono";
import { randomUUID } from "node:crypto";
import type { AppEnv } from "../types.js";
import { validate } from "../lib/validate.js";
import { CreateIssueSchema, type Issue } from "../schemas/issue.js";

const issues: Issue[] = []

export const issueRoutes = new Hono<AppEnv>()

issueRoutes.get('/', (c) => c.json({
  items: issues
}))
issueRoutes.post('/', validate('json', CreateIssueSchema), (c) => {
  const input = c.req.valid('json')
  const now = new Date().toISOString()
  const issue: Issue = {
    id: randomUUID(),
    storeId: 'store-001',
    ...input,
    status: 'OPEN',
    assigneeId: null,
    createdAt: now,
    updatedAt: now,
  }
  issues.push(issue)
  return c.json(issue, 201)
})