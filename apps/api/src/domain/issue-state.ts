import type { IssueStatusValue } from "../schemas/issue.js";

const NEXT: Record<IssueStatusValue, readonly IssueStatusValue[]> = {
  OPEN: ['ASSIGNED'],
  ASSIGNED: ['IN_PROGRESS', 'OPEN'],
  IN_PROGRESS: ['RESOLVED'],
  RESOLVED: [],
}

export function allowedNext(from: IssueStatusValue): readonly IssueStatusValue[] {
  return NEXT[from]
}
export function canTransition(from: IssueStatusValue, to: IssueStatusValue): boolean {
  return NEXT[from].includes(to)
}