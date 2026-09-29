type Level = 'debug' | 'info' | 'warn' | 'error'

export function log(
  level: Level, 
  message: string, 
  fields: Record<string, unknown> = {}
) {
  const line = JSON.stringify({ 
    time: new Date().toISOString(),
    level,
    service: 'api',
    message,
    ...fields
  })
  if (level === 'error') console.error(line)
  else console.log(line)
}