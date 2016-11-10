local awful       = require("awful")
awful.rules       = require("awful.rules")
awful.clientdb    = require("awful.clientdb")
awful.dbg         = require("awful.dbg")
awful.indicator   = require("awful.indicator")
awful.screensaver = require("awful.screensaver")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local quake = require("quake")
local unity  = require("unity")
local lain = require("lain")

-- When loaded, this module makes sure that there's always a client that will have focus
require("awful.autofocus")

-- Initializes the theme system
beautiful.init(awful.util.getdir("config").."/themes/level/theme.lua")


-- This is used later as the default terminal and editor to run.
--terminal = "tortosa -c \"" .. home_dir .. "/.config/tortosa/tortosa_awesome.rc\""
terminal = "Urxvt"
editor = os.getenv("EDITOR") or "geany"
editor_cmd = terminal .. " -e " 
music_player = "mocp"
language = string.gsub(os.getenv("LANG"), ".utf8", "")
os.setlocale(os.getenv("LANG"))

-- Default system software
software = { terminal = "urxvt",
             terminal_cmd = "urxvt -e ",
             terminal_quake = "urxvt -pe tabbed",
             editor = "ec",
             editor_cmd = "ec ",
             browser = "firefox",
             browser_cmd = "firefox " }

-- Initialize screensaver
awful.screensaver({
    time = 3600, -- 1 hour
    activate = { "mpc volume 10" },
    deactivate = { "mpc volume 80" },
    mod = "clock",
    mod_config = { format = "%H %M %S", font = "Crashed Scoreboard 200" }
})

layouts = {
   awful.layout.suit.floating, 	        -- 1
   awful.layout.suit.tile, 		-- 2
   awful.layout.suit.tile.bottom,	-- 3
   awful.layout.suit.tile.left,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.spiral,
}



-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
do
   local f, t, b, fl, fs, fm = layouts[1], layouts[2], layouts[3], layouts[4], layouts[5], layouts[6]
   for s = 1, screen.count() do
      -- Each screen has its own tag table.
      tags[s] = awful.tag({ " 𝟏 ", " 𝟐 ", " 𝟑 ", " 𝟒 ", " 𝟓 ", " 𝟔 "}, s,
                          {  fm ,  f ,  f ,  f ,  f ,  fl })
   end
end
-- }}}
	
   --Lain widgets

  mocwidget = lain.widgets.contrib.moc()



--local unitybar = unity.unitybar({ position = beautiful.unitybar.position, width = beautiful.unitybar.width,
 --                                 img_focused = beautiful.unitybar.img_focused })

-- Wibox table
local bar  = {}

-- Keybindings table
local keys = {}



-- Create wibox 'main'
bar["main"] = awful.wibox({ position = beautiful.wibox.position, width = beautiful.wibox.width })
bar["main"]:set_bg(beautiful.wibox.bg)

bar["top"] = wibox.layout.fixed.vertical()
bar["top"]:add(unity.menu_layout())
bar["top"]:add(unity.prompt())
bar["top"]:add(unity.weather())

bar["middle"] = wibox.layout.fixed.vertical()
bar["middle"]:add(unity.unitybar())

bar["bottom"] = wibox.layout.fixed.vertical()
bar["bottom"]:add(unity.net_up())
bar["bottom"]:add(unity.net_down())
bar["bottom"]:add(unity.zfs())
bar["bottom"]:add(unity.memory())
bar["bottom"]:add(unity.cpu())
bar["bottom"]:add(unity.mixer_places())
bar["bottom"]:add(unity.calendar())
bar["bottom"]:add(unity.clock())
bar["bottom"]:add(unity.skb_exit())


bar["wibox"] = wibox.layout.align.vertical()
bar["wibox"]:set_top(bar["top"])
bar["wibox"]:set_middle(bar["middle"])
bar["wibox"]:set_bottom(bar["bottom"])

bar["main"]:set_widget(bar["wibox"])
-- Spawn a program.
local function spawn(cmd)
    awful.util.spawn(cmd, false)
end




-- Kill window
local function killClient()
    awful.dbg.info("Select the window whose client you wish to kill with button 1....")
    awful.util.spawn("xkill")
end

-- Mouse bindings
keys["mouse"] = awful.util.table.join(
    awful.button({ }, 3, function() unity.menu_layout.main_app() end)
)
-- Client mouse bindings
keys["buttons"] = awful.util.table.join(
    awful.button({        }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ "Mod4" }, 1, awful.mouse.client.move                    ),
    awful.button({ "Mod4" }, 3, awful.mouse.client.resize                  )
)

-- Client keys
keys["client"] = awful.util.table.join(
    -- Show/Hide client's titlebar.
    awful.key({ "Mod4"            }, "Insert",       function(c) gadjets.titlebar(c)                         end),
    awful.key({ "Mod4"            }, "Delete",       function(c) awful.titlebar.hide(c)                      end),
    awful.key({ "Mod4",           }, "o",                     smart_movetoscreen                                ),
    -- Kill a client.
    awful.key({ "Mod4"            }, "k",            function(c) c:kill()                                    end),
    -- Set client maximized or not
    awful.key({ "Mod4"            }, "m",            function(c)
        if c.maximized_horizontal or c.maximized_vertical then
            c.maximized_horizontal = false c.maximized_vertical = false
        else
            c.maximized_horizontal = true c.maximized_vertical = true
        end
    end),
    -- Moving and resizing client's (does't not work with all clients)
    awful.key({ "Mod4", "Control" }, "Left",         function(c) awful.client.moveresize(-5,  0,  0,  0, c)  end), --[ - x ]
    awful.key({ "Mod4", "Control" }, "Right",        function(c) awful.client.moveresize( 5,  0,  0,  0, c)  end), --[ + x ]
    awful.key({ "Mod4", "Control" }, "Up",           function(c) awful.client.moveresize( 0, -5,  0,  0, c)  end), --[ - y ]
    awful.key({ "Mod4", "Control" }, "Down",         function(c) awful.client.moveresize( 0,  5,  0,  0, c)  end), --[ + y ]
    awful.key({ "Mod4", "Mod1"    }, "Left",         function(c) awful.client.moveresize( 0,  0, -5,  0, c)  end), --[ - w ]
    awful.key({ "Mod4", "Mod1"    }, "Right",        function(c) awful.client.moveresize( 0,  0,  5,  0, c)  end), --[ + w ]
    awful.key({ "Mod4", "Mod1"    }, "Up",           function(c) awful.client.moveresize( 0,  0,  0, -5, c)  end), --[ - h ]
    awful.key({ "Mod4", "Mod1"    }, "Down",         function(c) awful.client.moveresize( 0,  0,  0,  5, c)  end), --[ + h ]
    -- Honor size hints
    awful.key({ "Mod4"            }, "h",            function(c) c.size_hints_honor = not c.size_hints_honor end),
    -- Toggle client above normal windows
    awful.key({ "Mod4"            }, "a",            function(c) c.above = not c.above                       end),
    -- Toggle client below normal windows
    awful.key({ "Mod4"            }, "b",            function(c) c.below = not c.below                       end),
    -- The client is on top of every other windows
    awful.key({ "Mod4"            }, "t",            function(c) c.ontop = not c.ontop                       end),
    -- Set client sticky (available on all tags)
    awful.key({ "Mod4"            }, "s",            function(c) c.sticky = not c.sticky                     end),
    -- Set client fullscreen or not.
    awful.key({ "Mod4"            }, "f",            function(c) c.fullscreen = not c.fullscreen             end),
    -- Toggle the floating state
    awful.key({ "Mod4"            }, "v",            awful.client.floating.toggle                               ),
    -- Save client
    --awful.key({ "Mod4"            }, "w",            function(c) awful.clientdb.save(c)                      end),
    -- Show client menu
    awful.key({ "Mod4"            }, "c",            function(c) widgets.tasklist.main(c)                    end)
)

--  Key bindings
keys["global"] = awful.util.table.join(
    awful.key({ "Mod4",           }, "Left",   awful.tag.viewprev       ),
    awful.key({ "Mod4",           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Mod4"            }, "a",            function(c) c.above = not c.above                       end),
    -- Prompt
    awful.key({ "Mod4"            }, "l",            function() unity.prompt.lua()                         end),
    awful.key({ "Mod4"            }, "x",            function() unity.prompt.run()                         end),
    awful.key({ "Mod4"            }, "r",            function() unity.prompt.run()                         end),
    awful.key({ "Mod4"            }, "z",            function() unity.prompt.cmd()                         end),
    -- Layout menu
    awful.key({ "Mod4"            }, "space",        function() unity.layout.main()                        end),
    -- Applications menu
    awful.key({ "Mod4"            }, "q",            function() unity.menu_layout.main_qapp()                     end),
   awful.key({ "Mod1"            }, "x",            function() gadjets.xombrero.main_xapp()                     end),
 
    awful.key({ "Mod4"            }, "e",            function() unity.exit.main_eapp()                     end),
    awful.key({ "Mod1"            }, "v",            function() unity.mixer_places.main()                         end),
    awful.key({ "Mod4", "Shift"   }, "q",            function() unity.menu.main_app()                      end),
    awful.key({         "Shift"   }, "Menu",         function() unity.menu.main_app()                      end),
    -- Notifications history
   -- awful.key({ "Mod4",           }, "n",            function() gadjets.notifications.main()                 end),
    -- Change tags
    awful.key({ "Mod4",           }, "t" ,           function() gadjets.taglist.main()                       end),
    awful.key({ "Mod1",           }, "b" ,           function() unity.bass.main()                       end),
    awful.key({ "Mod1",           }, "t" ,           function() unity.treble.main()                       end),
   
    -- Places menu
    awful.key({ "Mod4"            }, "p",            function() unity.places.main()                        end),
    awful.key({ "Mod4"            }, "s",            function() unity.places.main()                        end),
    -- Select clients with the alt+tab menu
    awful.key({ "Mod1"            }, "Tab",          function() gadjets.altTab()                             end),
    -- Revert tag history.
    awful.key({ "Control"         }, "Tab",          awful.tag.history.restore                                  ),
   
 
    -- 
    awful.key({ "Mod4"            }, "Tab",          function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
     -- Qauke program
   awful.key({ "Mod4",           }, "Return", function () quake.toggle({ terminal = software.terminal_quake,
                                                                         name = "URxvt",
                                                                         height = 0.5,
                                                                         skip_taskbar = true,
                                                                         ontop = true })
                                              end),
    -- Focus
    
    awful.key({ "Mod4",           }, "Up",           function() awful.indicator.focus.bd("up")               end),
    awful.key({ "Mod4",           }, "Down",         function() awful.indicator.focus.bd("down")             end),
    -- Move
    awful.key({ "Mod4", "Shift"   }, "Left",         function() awful.indicator.focus.bd("left",nil,true)    end),
    awful.key({ "Mod4", "Shift"   }, "Right",        function() awful.indicator.focus.bd("down",nil,true)    end),
    awful.key({ "Mod4", "Shift"   }, "Up",           function() awful.indicator.focus.bd("up",nil,true)      end),
    awful.key({ "Mod4", "Shift"   }, "Down",         function() awful.indicator.focus.bd("down",nil,true)    end),
    -- Volume controls
    awful.key({ "Mod1"            }, ".",       function() spawn("mixer vol +5:+5 pcm +5:+5")    end),
    awful.key({ "Mod1"            }, ",",  function() spawn("mixer vol -5:-5 pcm -5:-5")    end),
    
    -- Music Player Daemon
    awful.key({ "Mod4", "Shift"   }, "KP_Add",       function() spawn("/usr/bin/mpc volume +5")              end),
    awful.key({ "Mod4", "Shift"   }, "KP_Subtract",  function() spawn("/usr/bin/mpc volume -5")              end),
    awful.key({ "Mod4"            }, "Prior",        function() spawn("/usr/bin/mpc prev")                   end),
    awful.key({ "Mod4"            }, "Next",         function() spawn("/usr/bin/mpc next")                   end),
    -- Awesome WM quit/restart
    awful.key({ "Mod4", "Control" }, "r",            awesome.restart                                            ),
    awful.key({ "Mod4", "Control" }, "q",            awesome.quit                                               ),
    -- Swap a client by its relative index.
    awful.key({ "Mod1",           }, "bracketright", function() awful.client.swap.byidx(  1)                 end),
    awful.key({ "Mod1",           }, "bracketleft",  function() awful.client.swap.byidx( -1)                 end),
    -- Increase master width factor.
    awful.key({ "Mod4",           }, "bracketright", function() awful.tag.incmwfact( 0.01)                   end),
    awful.key({ "Mod4",           }, "bracketleft",  function() awful.tag.incmwfact(-0.01)                   end),
    -- Increase the number of master windows.
    awful.key({ "Mod4", "Shift"   }, "bracketright", function() awful.tag.incnmaster( 1)                     end),
    awful.key({ "Mod4", "Shift"   }, "bracketleft",  function() awful.tag.incnmaster(-1)                     end),
    -- Increase number of column windows.
    awful.key({ "Mod4", "Control" }, "bracketright", function() awful.tag.incncol( 1)                        end),
    awful.key({ "Mod4", "Control" }, "bracketleft",  function() awful.tag.incncol(-1)                        end)   
)

-- Bind numpad to tag switcher
local tags = awful.tag.gettags(1)
local np_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
for i,_ in ipairs(tags) do
    local tag = awful.tag.gettags(1)[i]
    keys["global"] = awful.util.table.join(keys["global"],
        awful.key({ "Mod4"            }, "#"..(np_map[i] or 0),
            function() if tag then awful.tag.viewonly(tag) end end),
        awful.key({ "Mod4", "Control" }, "#"..(np_map[i] or 0),
            function() if tag and client.focus then awful.client.movetotag(tag) awful.tag.viewonly(tag) end end)
    )
end

-- Set keys
root.keys(keys["global"])
root.buttons(keys["mouse"])

-- All clients will match this rule.
awful.rules.rules = {{ rule = { },
    properties = { border_width = beautiful.border_width, border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        keys = keys["client"], buttons = keys["buttons"],
        floating = false, size_hints_honor = true
    }
}}    

-- }}}

-- Initializes the windows rules system
awful.clientdb.load()

-- Sometimes dialogs apears to fast...
table.insert(awful.rules.rules, {rule = { type = "dialog" }, properties = { floating = true }})

--local titlebars_enabled = false
-- Signals emitted on client objects
client.connect_signal("manage", function(c,startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c) client.focus = c end)
    if c.type == "dialog" then
        awful.client.floating.set(c)
        awful.placement.centered(c)
        c.ontop = true
    --    if beautiful.titlebar["dialog"] then  widgets.titlebar(c) end
   -- elseif awful.client.floating.get(c) then
--        if beautiful.titlebar["float"] then widgets.titlebar(c) end
    end
    if beautiful.titlebar["all"] then widgets.titlebar(c) end
end)

-- when a client gains focus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

-- when a client looses focus
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- {{{ Autostart applications

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
 end 

run_once("kbdd")
--run_once("setxkbmap -layout us,ru -variant , -option -option grp:alt_shift_toggle")
run_once("~/.autostart.sh")
-- }}}


