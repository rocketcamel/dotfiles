import { bind, Variable } from "astal"
import { get_disk_space } from "./cpu"

let disk_space = Variable(get_disk_space()).poll(5000, () => get_disk_space())
export default function Disk() {
  return <box className="status-box">
    <label label={bind(disk_space).as((s) => `${s}`)} />
  </box>
}

