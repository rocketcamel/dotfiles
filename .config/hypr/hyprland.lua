local terminal = "ghostty"
local file_manager = "ghostty -e yazi"

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
	},

	decoration = {
		rounding = 10,

		blur = {
			enabled = false,
		},
	},

	dwindle = {
		preserve_split = true,
	},

	input = {
		kb_layout = "us,jp",
		touchpad = {
			natural_scroll = true,
			disable_while_typing = false,
		},
	},

	animations = {
		enabled = true,
	},
})

--stylua: ignore start

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("windowIn", {type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1} }})
hl.curve("windowOut", {type = "bezier", points = { {0.3, -0.3}, {0, 1.1} }})
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = false,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 6,  bezier = "windowIn",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = false,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = false,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = false,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = false,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = false,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = false,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = false,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = false,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = false,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = false,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

--stylua: ignore end

local modifier = "SUPER"
local menu = "rofi -show drun"
local bluetooth = "blueman-manager"
local notifications = "swaync-client -t"
local lock_screen = "loginctl lock-session"

local function concat(bind)
	return modifier .. " + " .. bind
end

hl.bind(concat("Return"), hl.dsp.exec_cmd(terminal))
hl.bind(concat("SHIFT + Q"), hl.dsp.window.close())
hl.bind(concat("SHIFT + E"), hl.dsp.exit())
hl.bind(concat("SHIFT + Space"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(concat("E"), hl.dsp.exec_cmd(file_manager))
hl.bind(concat("D"), hl.dsp.exec_cmd(menu))
hl.bind(concat("SHIFT + D"), hl.dsp.exec_cmd("~/dotfiles/scripts/workspace.sh"))
hl.bind(concat("SHIFT + V"), hl.dsp.exec_cmd("~/dotfiles/scripts/copy.sh"))
hl.bind(concat("SHIFT + S"), hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh"))
hl.bind(concat("P"), hl.dsp.exec_cmd("~/dotfiles/scripts/project.sh"))
hl.bind(concat("B"), hl.dsp.exec_cmd(bluetooth))
hl.bind(concat("F"), hl.dsp.window.fullscreen())
hl.bind(concat("N"), hl.dsp.exec_cmd(notifications))
hl.bind(concat("Space"), hl.dsp.layout("togglesplit"))
hl.bind(concat("U"), hl.dsp.exec_cmd(lock_screen))

hl.bind(concat("H"), hl.dsp.focus({ direction = "left" }))
hl.bind(concat("L"), hl.dsp.focus({ direction = "right" }))
hl.bind(concat("J"), hl.dsp.focus({ direction = "down" }))
hl.bind(concat("K"), hl.dsp.focus({ direction = "up" }))

hl.bind(concat("SHIFT + H"), hl.dsp.window.move({ direction = "left" }))
hl.bind(concat("SHIFT + L"), hl.dsp.window.move({ direction = "right" }))

hl.bind(concat("CTRL + H"), hl.dsp.window.move({ direction = "left" }))
hl.bind(concat("CTRL + L"), hl.dsp.window.move({ direction = "right" }))

hl.bind(concat("mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(concat("mouse:273"), hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
	local key = i % 10

	hl.bind(concat(key), hl.dsp.focus({ workspace = i }))
	hl.bind(concat("SHIFT + " .. key), hl.dsp.window.move({ workspace = i }))
end

--stylua: ignore start

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness raise"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness lower"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--stylua: ignore end

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

local autostart_apps = {
	"qs",
	"wl-clip-persist --clipboard regular",
	"kanshi",
	"awww img ~/.config/wallpaper/asakusa.png",
}

hl.on("hyprland.start", function()
	for _, cmd in pairs(autostart_apps) do
		hl.exec_cmd(cmd)
	end
end)

local window_rules = {
	{
		name = "prismlauncher",
		match = { class = "org.prismlauncher.PrismLauncher" },
		float = true,
		size = { 900, 600 },
	},
	{
		name = "pavucontrol",
		match = { class = ".*pavucontrol*." },
		float = true,
		size = { 800, 600 },
	},
	{
		name = "thunar",
		match = { class = "thunar" },
		float = true,
	},
	{
		name = "xdg-desktop-portal-gtk",
		match = { class = "thunar" },
		float = true,
		size = { 1000, 600 },
	},
	{
		name = "steam",
		match = { class = "steam" },
		float = true,
	},
	{
		name = "blueman",
		match = { class = ".blueman-manager-wrapped" },
		float = true,
		size = { 800, 600 },
	},
}

for _, rule in pairs(window_rules) do
	hl.window_rule(rule)
end
