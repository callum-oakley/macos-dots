import { serve } from "https://deno.land/std@0.74.0/http/server.ts"
import {
  acceptWebSocket,
  WebSocket,
} from "https://deno.land/std@0.74.0/ws/mod.ts"
import { decode } from "https://deno.land/std@0.74.0/encoding/utf8.ts"

let sink: WebSocket | undefined = undefined

for await (const req of serve(":13748")) {
  switch (req.url) {
    case "/out":
      sink = await acceptWebSocket({
        conn: req.conn,
        bufReader: req.r,
        bufWriter: req.w,
        headers: req.headers,
      })
      break
    case "/in":
      if (sink) {
        try {
          // TODO Is there some unnecessary copying going on here? Can we wire
          // up some appropriate readers and writers instead?
          await sink.send(decode(await Deno.readAll(req.body)))
          req.respond({})
        } catch (err) {
          // Nobody is listening; no matter.
        }
      }
      break
  }
}
