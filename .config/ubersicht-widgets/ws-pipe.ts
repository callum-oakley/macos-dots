import { serve } from "https://deno.land/std@0.74.0/http/server.ts"
import {
  acceptWebSocket,
  WebSocket,
} from "https://deno.land/std@0.74.0/ws/mod.ts"
import { decode } from "https://deno.land/std@0.74.0/encoding/utf8.ts"
import { v4 } from "https://deno.land/std@0.67.0/uuid/mod.ts"

const subscribers: Record<string, WebSocket> = {}

for await (const req of serve(":13748")) {
  switch (req.method) {
    case "GET": {
      const id = v4.generate()
      console.log(`adding subscriber ${id}`)
      subscribers[id] = await acceptWebSocket({
        conn: req.conn,
        bufReader: req.r,
        bufWriter: req.w,
        headers: req.headers,
      })
      break
    }
    case "POST": {
      const message = decode(await Deno.readAll(req.body))
      console.log(
        `sending ${message} to ${Object.keys(subscribers).length} subscribers`
      )
      Object.entries(subscribers).map(async ([id, ws]) => {
        try {
          await ws.send(message)
        } catch (error) {
          console.log(`removing subscriber ${id}`)
          delete subscribers[id]
        }
      })
      req.respond({})
      break
    }
  }
}
