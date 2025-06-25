import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { bind, derive, GLib, Variable } from "astal"
import Hyprland from "gi://AstalHyprland"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import GTop from "gi://GTop"
import { calc_cpu_usage, get_cpu_snapshot, get_disk_space, get_ram_info } from "./cpu"
import AstalBattery from "gi://AstalBattery"

const time = Variable("").poll(1000, "date")

function Workspaces() {
  const hypr = Hyprland.get_default()

  return <box className="workspaces">
    {bind(hypr, "workspaces").as(wss => wss.filter(ws => !(ws.id >= -99 && ws.id <= -2))
      .sort((a, b) => a.id - b.id)
      .map(ws => (
        //@ts-ignore
        <button
          className={bind(hypr, "focusedWorkspace").as(fw =>
            ws === fw ? "focused" : "")}
          onClicked={() => ws.focus()}>
          {ws.id}
        </button>
      )))}
  </box>
}

function Audio() {
  const speaker = Wp.get_default()?.default_speaker!
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

function NetworkModule() {
  const network = Network.get_default()
  const wifi = network.wifi;
  const wired = network.wired

  const derived = Variable.derive([bind(network, "primary"), bind(wifi, "ssid"), bind(wifi, "strength")], (primary, ssid, strength) => {
    if (primary === Network.Primary.WIRED) {
      return { label: "🖧 Wired" }
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

let s1 = get_cpu_snapshot();
let cpu_usage_percent = Variable(0);
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  const s2 = get_cpu_snapshot();
  cpu_usage_percent.set(calc_cpu_usage(s1, s2));
  s1 = s2;

  return true;
});
function Cpu() {
  return <box className="status-box">
    <label label={bind(cpu_usage_percent).as((u) => `${u}% `)} />
  </box>
}

let info = Variable(get_ram_info())
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  info.set(get_ram_info())

  return true
})
function Ram() {
  return <box className="status-box">
    <label label={bind(info).as((i) => `${Math.round((i.used / i.total) * 100)}% `)} />
  </box>
}

let disk_space = Variable(get_disk_space()).poll(5000, () => get_disk_space())
function Disk() {
  return <box className="status-box">
    <label label={bind(disk_space).as((s) => `${s}`)} />
  </box>
}

function Battery() {
  const battery = AstalBattery.get_default()
  const battery_info = Variable.derive([bind(battery, "percentage"), bind(battery, "charging")], (percentage, charging) => {
    const full_percentage = Math.floor(percentage * 100)
    if (charging) {
      return { label: `${full_percentage == 100 ? "FULL" : "CHR"}: ${full_percentage}%` }
    }
    return { label: `${full_percentage == 100 ? "FULL" : "BAT"}: ${full_percentage}%` }
  })

  return <box className="status-box">
    <label label={battery_info((i) => i.label)} />
  </box>
}

let current_time = Variable(GLib.DateTime.new_now_local().format("%H:%M"))
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, () => {
  const now = GLib.DateTime.new_now_local()
  current_time.set(now.format("%H:%M"))
  return true
})
function Time() {

  return <box className="status-box">
    <label label={bind(current_time)} />
  </box>
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

  //@ts-ignore
  return <window
    className="Bar"
    gdkmonitor={gdkmonitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={BOTTOM | LEFT | RIGHT}
    application={App}>
    <centerbox>
      <box hexpand halign={Gtk.Align.START} >
        <box className="nix-icon">
          <icon icon="nixos-3" />
        </box>
        <Workspaces />
      </box>
      <box></box>
      <box hexpand halign={Gtk.Align.END}>
        <Audio />
        <NetworkModule />
        <Cpu />
        <Ram />
        <Disk />
        <Battery />
        <Time />
      </box>
    </centerbox>
  </window>
}
