local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local radical   = require("radical")
local l    = require("compact.layout")
local a       = require("compact.sox")
local p    = require("compact.places")

local function new()
    local layout = wibox.layout.flex.vertical()
    local top_layout = wibox.layout.fixed.horizontal()
    top_layout:add(l())   
    top_layout:add(p())
    
    local bottom_layout = wibox.layout.fixed.horizontal()        
  
    bottom_layout:add(a())
    
    layout:add(top_layout)
    layout:add(bottom_layout)
    return layout
end

return (function(_, ...) return new(...) end )
