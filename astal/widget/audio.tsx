import { bind, Variable } from "astal"
import AstalWp from "gi://AstalWp?version=0.1"

export default function Audio() {
  const speaker = AstalWp.get_default()?.default_speaker!
  const derived = Variable.derive([bind(speaker, "volume"), bind(speaker, "mute")], (volume: number, muted: boolean) => {
    if (muted) {
      return { label: ` (muted)`, muted }
    }
    return { label: `${Math.floor(volume * 100)}% ` }
  })

  return <box className={derived((v) => ["status-box", v.muted && "inactive"].filter(Boolean).join(" "))}>
    <label
      label={derived((v) => v.label)} />
  </box>
}
