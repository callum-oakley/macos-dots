import { css, run } from "uebersicht"

const cpuBlinkInterval = 5000

export const className = `
  width: 100%;
  text-align: center;
  font-size: 16pt;
  font-family: monospace;
`

const black = css`
  color: #222;
`

const white = css`
  color: #fff;
`

const red = css`
  color: #e00;
`

export const init = (dispatch) => {
  console.log("starting ws-pipe")
  run(
    "/usr/local/bin/deno run --allow-net file:///Users/callum/.config/ubersicht-widgets/ws-pipe.ts &>/dev/null || true"
  )

  // Wait for a second before trying to connect to give the server a chance to
  // start.
  setTimeout(() => {
    console.log("establishing websocket")
    const ws = new WebSocket("ws://localhost:13748")
    ws.addEventListener("message", (event) => {
      dispatch({ type: "mods", mods: JSON.parse(event.data) })
    })
  }, 1000)

  // Blink the CPU light every cpuBlinkInterval seconds. The duration of the
  // blink indicates the CPU utilisation. If the CPU is running at p%, the
  // light will be on for p% of the interval.
  let blinkTimeout
  setInterval(async () => {
    const cpu = parseInt(
      await run(`ps -A -o %cpu | awk '{ s += $1 } END { print s }'`)
    )
    clearTimeout(blinkTimeout)
    dispatch({ type: "cpuBlink", cpuBlink: true })
    blinkTimeout = setTimeout(() => {
      dispatch({ type: "cpuBlink", cpuBlink: false })
    }, (cpuBlinkInterval * cpu) / 100)
  }, cpuBlinkInterval)
}

export const initialState = {
  mods: {},
  cpuBlink: false,
}

export const updateState = (event, previousState) => {
  switch (event.type) {
    case "mods": {
      return { ...previousState, mods: event.mods }
      break
    }
    case "cpuBlink": {
      return { ...previousState, cpuBlink: event.cpuBlink }
    }
  }
}

export const render = ({ mods, cpuBlink }) => (
  <div>
    <Light key="cpuBlink" on={cpuBlink} onColor={red} offColor={black}></Light>
    <span> </span>
    <Light key="cmd" on={mods.cmd} onColor={white} offColor={black}></Light>
    <Light key="alt" on={mods.alt} onColor={white} offColor={black}></Light>
    <Light key="ctrl" on={mods.ctrl} onColor={white} offColor={black}></Light>
    <Light key="shift" on={mods.shift} onColor={white} offColor={black}></Light>
  </div>
)

const Light = ({ on, onColor, offColor }) => (
  <span className={on ? onColor : offColor}>·</span>
)
