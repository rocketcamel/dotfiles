import { App, Gdk } from "astal/gtk3";
import style from "./style.scss";
import Bar from "./widget/Bar";
import { GLib } from "astal";

App.start({
  css: style,
  icons: "icons",
  main() {},
});

let knownMonitors = new Set();

function checkMonitors() {
  const currentMonitors = App.get_monitors();
  currentMonitors.forEach((monitor) => {
    if (!knownMonitors.has(monitor.model)) {
      knownMonitors.add(monitor.model);
      Bar(monitor);
    }
  });
}

checkMonitors();

GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 10, () => {
  checkMonitors();
  return true;
});
