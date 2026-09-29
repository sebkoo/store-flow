import { zValidator } from "@hono/zod-validator";
import type { ZodType } from "zod";
import { ApiError } from "./errors.js";

type Target = 'json' | 'query' | 'param'

export const validate = <K extends Target, T extends ZodType>(target: K, schema: T) => 
  zValidator(target, schema, (result) => {
    if (!result.success) {
      const details = result.error.issues.map((issue) => ({
        path: issue.path.map(String).join('.'),
        message: issue.message
      }))
      throw new ApiError(400, 'VALIDATION_FAILED', 'Request validation failed', details)
    }
  })