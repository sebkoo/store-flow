import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import type { ContentfulStatusCode } from "hono/utils/http-status";
import type { AppEnv } from "../types.js";
import { log } from "./log.js";

export type ErrorDetail = { 
  path: string
  message: string
}

export class ApiError extends Error {
  readonly status: ContentfulStatusCode
  readonly code: string
  readonly details?: ErrorDetail[]

  constructor(
    status: ContentfulStatusCode,
    code: string,
    message: string,
    details?: ErrorDetail[]
  ) {
    super(message)
    this.status = status
    this.code = code
    this.details = details
  }
}

export function handleError(
  err: Error, 
  c: Context<AppEnv>
) {
  const requestId = c.get('requestId')
  if (err instanceof ApiError) {
    return c.json({ error: { 
      code: err.code,
      message: err.message,
      requestId,
      details: err.details
    }}, err.status)
  }
  if (err instanceof HTTPException) {
    const code = 
      err.status === 401
      ? 'UNAUTHENTICATED'
      : err.status === 400
        ? 'BAD_REQUEST'
        : 'HTTP_ERROR'
  }
  log('error', 'unhandled error', {
    requestId,
    error: err.message,
    stack: err.stack
  })
  return c.json({ error: {
    code: 'INTERNAL',
    message: 'Something went wrong',
    requestId
  }}, 500)
}