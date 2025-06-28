import { bind } from "astal"
import { Gdk } from "astal/gtk3"
import AstalHyprland from "gi://AstalHyprland?version=0.1"

export default function Workspaces({ monitor }: { monitor: Gdk.Monitor }) {
  const hypr = AstalHyprland.get_default()

  return <box className="workspaces">
    {bind(hypr, "workspaces").as(wss => wss.filter(ws => !(ws.id >= -99 && ws.id <= -2))
      .sort((a, b) => a.id - b.id)
      .map(ws => {
        if (ws.monitor.model !== monitor.model) return <></>
        return (
          <button
            className={bind(hypr, "focusedWorkspace").as(fw =>
              ws === fw ? "focused" : "")}
            onClicked={() => ws.focus()}>
            {ws.id}
          </button>
        )
      }))}
  </box>
}
