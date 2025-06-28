import { bind, Variable } from "astal";
import AstalNetwork from "gi://AstalNetwork?version=0.1";

export default function NetworkModule() {
  const network = AstalNetwork.get_default()
  const wifi = network.wifi;
  const wired = network.wired

  const derived = Variable.derive([bind(network, "primary"), bind(wifi, "ssid"), bind(wifi, "strength")], (primary, ssid, strength) => {
    if (primary === AstalNetwork.Primary.WIRED) {
      return { label: `🖧 Wired ${wired.device.interface}` }
    }
    if (wifi.active_access_point !== null) {
      return { label: `${ssid} (${strength}%) ` }
    }
    return { label: `Disconnected ⚠` }
  })

  return (
    <box className="status-box">
      <label
        label={derived((v) => v.label)} />
    </box>
  )
}

