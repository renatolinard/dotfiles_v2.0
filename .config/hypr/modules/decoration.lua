hl.config({
  general = {
    gaps_in                 = 12,
    gaps_out                = 18,
    border_size             = 0,
    layout                  = "dwindle",
    resize_on_border        = true,
    -- low-latency path for fullscreen games: only windows carrying the
    -- `immediate` rule (steam/games, see window_rules.lua) actually tear, so the
    -- desktop never does -- an unthrottled game does, cutting input lag and the
    -- Steam-overlay frame-time hit the vsynced compositor path adds.
    allow_tearing           = true,
    ["col.active_border"]   = active,
    ["col.inactive_border"] = inactive,
  },
  decoration = {
    rounding         = 12,
    rounding_power   = 4,
    active_opacity   = 1,
    inactive_opacity = 0.94,
    shadow           = {
      enabled      = not no_shadow,
      range        = 45,
      render_power = 4,
      color        = 0xd10a0807,
    },
    blur             = {
      enabled           = not no_blur,
      size              = 6,
      passes            = 1,
      vibrancy          = 0.17,
      noise             = 0.01,
      new_optimizations = true,
    },
  },
})
