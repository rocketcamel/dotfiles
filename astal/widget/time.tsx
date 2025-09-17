import { bind, GLib, Variable } from "astal"

let current_time = Variable(GLib.DateTime.new_now_local().format("%H:%M"))
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  const now = GLib.DateTime.new_now_local()
  current_time.set(now.format("%b %e (%a) %H:%M"))
  return true
})
export default function Time() {

  return <box className="status-box">
    <label label={bind(current_time)} />
  </box>
}

