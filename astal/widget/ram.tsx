import { bind, GLib, Variable } from "astal"
import { get_ram_info } from "./cpu"

let info = Variable(get_ram_info())
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  info.set(get_ram_info())

  return true
})

export default function Ram() {
  return <box className="status-box">
    <label label={bind(info).as((i) => `${Math.round((i.used / i.total) * 100)}% `)} />
  </box>
}

