import { bind, Variable } from "astal"
import AstalBattery from "gi://AstalBattery?version=0.1"

export default function Battery() {
  const battery = AstalBattery.get_default()
  const battery_info = Variable.derive([bind(battery, "percentage"), bind(battery, "charging")], (percentage, charging) => {
    const full_percentage = Math.floor(percentage * 100)
    if (charging) {
      return { label: `${full_percentage == 100 ? "FULL" : "CHR"}: ${full_percentage}%` }
    }
    return { label: `${full_percentage == 100 ? "FULL" : "BAT"}: ${full_percentage}%` }
  })

  if (!battery.is_battery) {
    return <></>
  }
  return <box className="status-box">
    <label label={battery_info((i) => i.label)} />
  </box>
}

