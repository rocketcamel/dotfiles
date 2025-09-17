import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Workspaces from "./workspaces";
import Audio from "./audio";
import NetworkModule from "./network";
import Cpu from "./cpu-widget";
import Ram from "./ram";
import Disk from "./disk";
import Battery from "./battery";
import Time from "./time";
import Title from "./title";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  //@ts-ignore
  return (
    <window
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <box className="nix-icon">
            <icon icon="nixos-3" />
          </box>
          <Workspaces monitor={gdkmonitor} />
        </box>
        <box className="client-title">
          <Title />
        </box>
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
  );
}
