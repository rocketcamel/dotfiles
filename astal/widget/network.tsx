import { bind, Variable } from "astal";
import AstalNetwork from "gi://AstalNetwork?version=0.1";

const disconnected_label = { label: `Disconnected ⚠` };

function create_label(
  primary: AstalNetwork.Primary,
  wired: AstalNetwork.Wired,
  wifi?: AstalNetwork.Wifi,
) {
  if (primary === AstalNetwork.Primary.WIRED) {
    return { label: `🖧 Wired ${wired.device.interface}` };
  }
  if (!wifi) {
    return disconnected_label;
  }
  if (wifi.active_access_point !== null) {
    return { label: `${wifi.ssid} (${wifi.strength}%) ` };
  }
  return disconnected_label;
}

export default function NetworkModule() {
  const network = AstalNetwork.get_default();
  const wifi = network.wifi;
  const wired = network.wired;

  let derived;
  if (!wifi) {
    derived = Variable.derive([bind(network, "primary")], (primary) => {
      return create_label(primary, wired);
    });
  } else {
    derived = Variable.derive(
      [bind(network, "primary"), bind(wifi, "ssid"), bind(wifi, "strength")],
      (primary) => {
        return create_label(primary, wired, wifi);
      },
    );
  }

  return (
    <box className="status-box">
      <label label={derived((v) => v.label)} />
    </box>
  );
}
