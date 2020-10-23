import { css, run } from "uebersicht"

export const className = `
  width: 100%;
  text-align: center;
  font-size: 16pt;
`

export const preCss = css`
  margin-top: 0;
`

export const errCss = css`
  margin-top: 0;
  font-size: 12pt;
`

const black = css`
  color: #222;
`

const white = css`
  color: #fff;
`

const blackAnimated = css`
  color: #222;
  transition: color 5s;
`

const whiteAnimated = css`
  color: #fff;
  transition: color 5s;
`

export const init = (dispatch) => {
  console.log("starting ws-pipe")
  run(
    "/usr/local/bin/deno run --allow-net file:///Users/callum/.config/ubersicht-widgets/ws-pipe.ts &>/dev/null || true"
  )

  setTimeout(() => {
    console.log("establishing websocket")
    const ws = new WebSocket("ws://localhost:13748")
    ws.addEventListener("message", (event) => {
      dispatch({ type: "mods", mods: JSON.parse(event.data) })
    })
  }, 1000)

  setInterval(() => {
    dispatch({ type: "blink" })
  }, 5000)
}

export const initialState = {
  mods: {},
  blink: false,
}

export const updateState = (event, previousState) => {
  switch (event.type) {
    case "mods": {
      return { ...previousState, mods: event.mods }
      break
    }
    case "blink": {
      return { ...previousState, blink: !previousState.blink }
    }
  }
}

export const render = ({ mods, blink }) => (
  <pre className={preCss}>
    <Light key="0" on={mods.shift} onColor={white} offColor={black}></Light>
    <Light key="1" on={mods.ctrl} onColor={white} offColor={black}></Light>
    <Light key="2" on={mods.alt} onColor={white} offColor={black}></Light>
    <Light key="3" on={mods.cmd} onColor={white} offColor={black}></Light>
    <span key="4"> </span>
    <Light
      key="5"
      on={blink}
      onColor={whiteAnimated}
      offColor={blackAnimated}
    ></Light>
    <span key="6"> </span>
    <Light key="7" on={mods.cmd} onColor={white} offColor={black}></Light>
    <Light key="8" on={mods.alt} onColor={white} offColor={black}></Light>
    <Light key="9" on={mods.ctrl} onColor={white} offColor={black}></Light>
    <Light key="10" on={mods.shift} onColor={white} offColor={black}></Light>
  </pre>
)

const Light = ({ on, onColor, offColor }) => (
  <span className={on ? onColor : offColor}>·</span>
)
