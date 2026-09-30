import { describe, expect, it } from "vitest";
import { allowedNext, canTransition } from "./issue-state.js"

describe('issue state machine', () => {
  it.each([
    ['OPEN', 'ASSIGNED'],
    ['ASSIGNED', 'IN_PROGRESS'],
    ['ASSIGNED', 'OPEN'],
    ['IN_PROGRESS', 'RESOLVED'],
  ] as const)('allows %s → %s', (from, to) => {
    expect(canTransition(from, to)).toBe(true)
  })
  it.each([
    ['OPEN', 'IN_PROGRESS'],
    ['OPEN', 'RESOLVED'],
    ['ASSIGNED', 'RESOLVED'],
    ['IN_PROGRESS', 'OPEN'],
    ['RESOLVED', 'OPEN'],
    ['OPEN', 'OPEN'],
  ] as const)('blocks %s → $s', (from, to) => {
    expect(canTransition(from, to)).toBe(false)
  })
  it('treats RESOLVED as a final state', () => {
    expect(allowedNext('RESOLVED')).toEqual([])
  })
  it('allows the full happy path', () => {
    const path = ['OPEN', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED'] as const
    for (let i = 0; i < path.length - 1; i++) {
      expect(canTransition(path[i], path[i + 1])).toBe(true)
    }
  })
})
