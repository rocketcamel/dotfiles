import { bind, GLib, Variable } from "astal";
import { calc_cpu_usage, get_cpu_snapshot } from "./cpu";

let s1 = get_cpu_snapshot();
let cpu_usage_percent = Variable(0);
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  const s2 = get_cpu_snapshot();
  cpu_usage_percent.set(calc_cpu_usage(s1, s2));
  s1 = s2;

  return true;
});

export default function Cpu() {
  return <box className="status-box">
    <label label={bind(cpu_usage_percent).as((u) => `${u}% `)} />
  </box>
}

