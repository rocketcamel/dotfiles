import { bind, Variable } from "astal"
import AstalHyprland from "gi://AstalHyprland?version=0.1";

const hyprland = AstalHyprland.get_default()

function get_title() {
  return hyprland.focusedClient?.title ?? ""
}

const title = Variable(get_title()).poll(200, () => get_title())

export default function Title() {
  return (
    <label label={title(t => t)} />
  )
}
