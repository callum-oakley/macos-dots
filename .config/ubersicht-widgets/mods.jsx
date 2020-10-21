import { css } from "uebersicht"

// Refresh only when told to
export const refreshFrequency = false

export const command = "cat ~/.mods.json"

export const className = `
  width: 100%;
  text-align: center;
  font-size: 16pt;
`

export const preCss = css`
  margin-top: 0;
`

const off = css`
  color: #222;
`

const on = css`
  color: #fff;
`
export const render = ({ output }) => {
  const mods = JSON.parse(output)
  const leftLights = ["shift", "ctrl", "alt", "cmd"].map((key) => (
    <span className={mods[key] === "down" ? on : off}>·</span>
  ))
  const rightLights = leftLights.reduce((acc, x) => [x, ...acc], [])
  return (
    <pre className={preCss}>
      {leftLights}
      <span> </span>
      {rightLights}
    </pre>
  )
}
