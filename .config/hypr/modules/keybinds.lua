hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("env GTK_IM_MODULE=simple ghostty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SHIFT + SUPER + w", hl.dsp.exec_cmd("waypaper --folder ~/wallpaper/"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + X", hl.dsp.exec_cmd("wlogout"))
--focus
hl.bind("SUPER + Left", hl.dsp.focus({direction = "left"}))
hl.bind("SUPER + Right", hl.dsp.focus({direction = "right"}))
hl.bind("SUPER + Up", hl.dsp.focus({direction = "up"}))
hl.bind("SUPER + Down", hl.dsp.focus({direction = "down"}))
--move
hl.bind("SUPER + SHIFT +Left", hl.dsp.window.move({direction = "left"}))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({direction = "right"}))
hl.bind("SUPER + SHIFT + Up ", hl.dsp.window.move({direction = "up"}))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({direction = "down"}))
--resize whit the mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {mouse = true})
-- launche app
hl.bind("SUPER + W", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
--workspace/move window to a workspace
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    if is_fr then
        key = fr_keys[i]
    end
    hl.bind("SUPER + " .. key,             hl.dsp.focus({ workspace = i}), { description = "Focus workspace " .. i })
    hl.bind("SUPER + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end
-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
--Brilho
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
--Screenshots
--print tela inteira
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/personal_scripts/screenshots.sh --now"))
hl.bind("PRINT", hl.dsp.exec_cmd("~/.config/hypr/personal_scripts/screenshots.sh --area"))

