-- #######################################################################################
-- CONFIGURAÇÃO CUSTOMIZADA DO HYPRLAND (LUA)
-- #######################################################################################

-- 1. MONITOR
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@75",
    position = "0x0",
    scale = "1",
})

-- 2. PROGRAMAS PRINCIPAIS
local terminal = "kitty"
local fileManager = "thunar"
local menu = "rofi -show drun"
local browser = "brave-origin-nightly"
local home = os.getenv("HOME") or "/home/victor"

local mainMod = "SUPER"

-- 3. VARIÁVEIS DE AMBIENTE
hl.env("XCURSOR_THEME", "GoogleDot-Black")
hl.env("XCURSOR_SIZE", "16")
hl.env("HYPRCURSOR_THEME", "GoogleDot-Black")
hl.env("HYPRCURSOR_SIZE", "16")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("LD_PRELOAD", "")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XDG_DATA_DIRS", "/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:" .. home .. "/.local/share/flatpak/exports/share")

-- 4. ANIMAÇÕES & BEZIERS
hl.curve("smoothOut", { type = "bezier", points = { { 0.25, 0.9 }, { 0.35, 1.0 } } })
hl.curve("smoothInOut", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.curve("subtle", { type = "bezier", points = { { 0.22, 0.9 }, { 0.3, 1.0 } } })
hl.curve("stylish", { type = "bezier", points = { { 0.2, 1.0 }, { 0.15, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "stylish", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "smoothInOut", style = "popin 96%" })
hl.animation({ leaf = "border", enabled = true, speed = 9, bezier = "subtle" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "smoothInOut" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "subtle", style = "slide bottom" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "smoothInOut", style = "slide bottom" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 4, bezier = "subtle" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 4, bezier = "smoothInOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "stylish", style = "slide" })

-- 5. ATALHOS DE TECLADO (BINDS)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("rofi -show hyprwin -modes 'window,hyprwin:~/.config/rofi/scripts/hyprwin.sh' -show-icons"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshot-$(date +'%Y%m%d-%H%M%S').png"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshot-$(date +'%Y%m%d-%H%M%S').png"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("grim -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshot-$(date +'%Y%m%d-%H%M%S').png"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(home .. "/.config/hypr/set-wallpaper.sh"))

-- Controle de Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume --limit 1.53 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Controle de Mídia (Spotify)
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("playerctl -p spotify previous"), { locked = true })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("playerctl -p spotify play-pause"), { locked = true })
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("playerctl -p spotify next"), { locked = true })
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd("playerctl -p spotify position 10-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("playerctl -p spotify position 10+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd("playerctl -p spotify loop Track"), { locked = true })
hl.bind(mainMod .. " + ALT + comma", hl.dsp.exec_cmd("playerctl -p spotify volume 0.1-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + ALT + period", hl.dsp.exec_cmd("playerctl -p spotify volume 0.1+"), { locked = true, repeating = true })

-- Navegação
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Grupos (Abas)
hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ out_of_group = true }))

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Workspaces 1 a 10
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Submap Resize
hl.bind(mainMod .. " + ALT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }))
    hl.bind("right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }))
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))
    hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- 6. REGRAS DE JANELAS
hl.window_rule({
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

-- 7. CONFIGURAÇÕES GERAIS
hl.config({
    input = {
        kb_layout = "us,br",
        kb_options = "grp:alt_caps_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        force_no_accel = true,
        repeat_rate = 100,
        repeat_delay = 100,
        touchpad = {
            natural_scroll = false,
        },
    },
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 0,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 5,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

-- 8. INICIALIZAÇÃO AUTOMÁTICA
hl.on("hyprland.start", function()
   hl.exec_cmd("waybar")
   hl.exec_cmd("hyprpaper")
   hl.exec_cmd("mako")
end)
