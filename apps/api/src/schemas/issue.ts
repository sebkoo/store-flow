import { z } from "zod";

export const IssueType = z.enum([
  'SCANNER_BROKEN',
  'POS_OFFLINE',
  'SHELF_FULL',
  'LOW_INVENTORY',
  'PRINTER_FAILURE',
  'OTHER'
])
export const IssuePriority = z.enum([
  'LOW', 
  'NORMAL', 
  'HIGH'
])
export const IssueStatus = z.enum([
  'OPEN', 
  'ASSIGNED', 
  'IN_PROGRESS', 
  'RESOLVED'
])

export const CreateIssueSchema = z.object({
  title: z.string().trim()
    .min(3, 'Title must be at least 3 characters')
    .max(120, 'Title must be at most 120 characters')
    .refine((t) => !/test/i.test(t), 
      'Title may not contain "test"'),
  type: IssueType,
  priority: IssuePriority.default('NORMAL')
})

export const ListIssuesQuery = z.object({
  status: IssueStatus.optional(),
  type: IssueType.optional()
})
export const IssueIdParam = z.object({
  id: z.uuid('Issue id must be a UUID')
})

export const TransitionSchema = z.object({
  to: IssueStatus,
  assigneeId: z.uuid('assigneeId must be a UUID').optional(),
}).refine((body) => body.to !== 'ASSIGNED' || 
                    body.assigneeId !== undefined, {
  error: 'assigneeId is required when assigning',
  path: ['assigneeId']
})

export type IssueStatusValue = z.infer<typeof IssueStatus>