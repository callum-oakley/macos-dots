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

export const init = (dispatch) => {
  console.log("starting ws-pipe")
  run(
    "/usr/local/bin/deno run --allow-net file:///Users/callum/.config/ubersicht-widgets/ws-pipe.ts &>/dev/null || true"
  )

  setTimeout(() => {
    console.log("establishing websocket")
    const ws = new WebSocket("ws://localhost:13748")
    ws.addEventListener("message", (event) => {
      dispatch({ output: JSON.parse(event.data) })
    })
  }, 1000)
}

export const render = ({ output: { shift, ctrl, alt, cmd } }) => (
  <pre className={preCss}>
    <Light key="0" on={shift}></Light>
    <Light key="1" on={ctrl}></Light>
    <Light key="2" on={alt}></Light>
    <Light key="3" on={cmd}></Light>
    <span key="4"> </span>
    <Light key="5" on={cmd}></Light>
    <Light key="6" on={alt}></Light>
    <Light key="7" on={ctrl}></Light>
    <Light key="8" on={shift}></Light>
  </pre>
)

const Light = ({ on }) => <span className={on ? white : black}>·</span>
