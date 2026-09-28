import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { randomUUID } from "node:crypto";
import { CreateIssueSchema, type Issue } from "../schemas/issue.js";

const issues: Issue[] = []

export const issueRoutes = new Hono()

issueRoutes.get('/', (c) => c.json({
  items: issues
}))
issueRoutes.post('/', zValidator('json', CreateIssueSchema), (c) => {
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