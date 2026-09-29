import { z } from "zod";

try {
  process.loadEnvFile('.env')
} catch (err) {
  console.warn(`[env] .env not loaded (${(err as Error).message}); using defaults and real environment variables`)
}

const EnvSchema = z.object({
  PORT: z.coerce.number().int().default(8787),
  DATABASE_URL: z.string().default('postgres://storeflow:storeflow@localhost:5432/storeflow'),
})

export const env = EnvSchema.parse(process.env)