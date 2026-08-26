-- HYPERLAND VERSÃO LUA 
-- ------MONITOR -------
require("modules.monitors")
--------INPUT-----------
require("modules.keyboard")
------AUTOSTART---------
require("modules.autostart")


---------ENV------------
hl.env("XCURSOR_SIZE", "36")
hl.env("XCURSOR_THEME", "material_dark_cursors")
------------------------

--LOOK AND FELL--------
require("modules.animation")
require("modules.decoration")
------------------------

-----------KEYBINDS----
require("modules.keybinds")
