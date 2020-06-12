import { css } from "uebersicht"

export const command = "~/bin/bar"

export const refreshFrequency = 10000

export const render = ({ output }) => {
  console.log("rendering")
  if (!output) {
    return null
  }
  const [left, middle, right] = output.split(" <> ")
  return (
    <pre
      className={css`
        font-family: "IBM Plex Mono", serif;
        font-size: 10pt;
        font-weight: 400;
        margin: 3px;
        display: flex;
      `}
    >
      <span
        className={css`
          flex: 1;
        `}
      >
        {left}
      </span>
      <span
        className={css`
          flex: 1;
          text-align: center;
        `}
      >
        {middle}
      </span>
      <span
        className={css`
          flex: 1;
          text-align: right;
        `}
      >
        {right}
      </span>
    </pre>
  )
}

export const className = `
  width: 2560px;
  height: 20px;
  color: #ddd;
`
