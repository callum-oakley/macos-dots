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

const off = css`
  color: #222;
`

const on = css`
  color: #fff;
`

export const init = async (dispatch) => {
  run(
    "/usr/local/bin/deno run --allow-net file:///Users/callum/.config/ubersicht-widgets/ws-pipe.ts"
  ).catch((error) => {
    if (!error.message.match(/AddrInUse/)) {
      dispatch({ error })
    }
  })

  setTimeout(
    () =>
      new WebSocket("ws://localhost:13748/out").addEventListener(
        "message",
        (event) => dispatch({ output: JSON.parse(event.data) })
      ),
    1000
  )
}

export const initialState = { output: {} }

export const render = ({ output, error }) => {
  if (error) {
    return <pre className={errCss}>{error.toString()}</pre>
  }
  return (
    <pre className={preCss}>
      {["shift", "ctrl", "alt", "cmd"].map((key, i) => (
        <span key={i} className={output[key] ? on : off}>
          ·
        </span>
      ))}
      <span key="4"> </span>
      {["cmd", "alt", "ctrl", "shift"].map((key, i) => (
        <span key={i + 5} className={output[key] ? on : off}>
          ·
        </span>
      ))}
    </pre>
  )
}
