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
export type CreateIssueInput = z.infer<typeof CreateIssueSchema>

export type Issue = {
  id: string
  storeId: string
  title: string
  type: z.infer<typeof IssueType>
  priority: z.infer<typeof IssuePriority>
  status: z.infer<typeof IssueStatus>
  assigneeId: string | null
  createdAt: string
  updatedAt: string
}