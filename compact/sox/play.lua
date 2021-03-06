local wibox         = require("wibox")
local awful         = require("awful")
local naughty       = require('naughty')
local beautiful     = require("beautiful")
local timer         = require("gears.timer")


local sox = {}
local function worker(args)
    local args = args or {}

    -- Settings
    local res         = ".config/awesome/themes/pattern/play/"
    local interface     = args.interface or "play"
    local timeout       = args.timeout or 5     
    local widget 	= args.widget == nil and wibox.layout.fixed.horizontal() or args.widget == false and nil or args.widget
    local indent 	= args.indent or 5

    local function keymap(...)
   local t = {}
   for _, k in ipairs({...}) do
      local but
      if type(k[1]) == "table" then
         but = awful.button(k[1], k[2], k[3])
      else
         but = awful.button({}, k[1], k[2])
      end
      t = awful.util.table.join(t, but)
   end
   return t
end
  local mouse = { LEFT = 1, MIDDLE = 2, RIGHT = 3, WHEEL_UP = 4, WHEEL_DOWN = 5 }

  function forward()
    io.popen("killall sox")
end
  
 function next()
    os.execute("zsh -c ~/.config/awesome/compact/sox/dr/play1.sh &")
end
    
  function stop()
    os.execute("pkill -f play")
end
   
   local function play()
    os.execute("zsh -c ~/.config/awesome/compact/sox/dr/play.sh &")
end   
   local compact ={} 
   local pl = awful.widget.button({ image = res .. "repeat.png" })
   local st = awful.widget.button({ image = res .. "stop.png" }) 
   local av = awful.widget.button({ image = res .. "play.png" })
   local ff = awful.widget.button({ image = res .. "next.png" })
   
	    widget:add(pl, st, av, ff)
            
  local notification
function playlist_status()
    awful.spawn.easy_async([[bash -c '~/.config/awesome/compact/sox/dr/playlist_status.sh']],
        function(stdout, _, _, _)
            notification = naughty.notify{
                text =  stdout,
                title = "Проигранное:",
                position      =  "bottom_left",
                timeout = 100, hover_timeout = 0.5,
                width = 530,
                preset  = notification_preset
            }
        end
    )
end
local naughty_timer = timer({ timeout = 10})
naughty_timer:connect_signal("timeout" ,playlist_status)

widget:connect_signal("mouse::enter", function() playlist_status() end)
widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end) 
widget:connect_signal("mouse::enter", function()naughty_timer:start(notification) end)
widget:connect_signal("mouse::leave", function()naughty_timer:stop(notification) end)
      av:buttons(
      keymap({ mouse.LEFT, function() play() end },
      { mouse.LEFT, function()naughty.destroy(n)end }))
        
      st:buttons(
      keymap({ mouse.LEFT, function() stop() end },
      { mouse.LEFT, function()naughty.destroy(n)end }))
           
      ff:buttons(
      keymap({ mouse.LEFT, function() forward() end },
      { mouse.LEFT, function()naughty.destroy(n)end }))
           
      pl:buttons(
      keymap({ mouse.LEFT, function()  next() end  },     
      { mouse.LEFT, function()naughty.destroy(n)end }))
            
      return widget
  end  
      
return setmetatable(sox, {__call = function(_,...) return worker(...) end})
