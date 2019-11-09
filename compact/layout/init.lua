local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local radical   = require("radical")
local common    = require("compact.common.helpers1")
local box_bl      = require("compact.layout.box_bl")


local module = {}

-- Layouts table
module.layouts = {
    awful.layout.suit.magnifier,         -- 1
    awful.layout.suit.tile,              -- 2
    awful.layout.suit.tile.left,         -- 3
    awful.layout.suit.tile.bottom,       -- 4
    awful.layout.suit.tile.top,          -- 5
    awful.layout.suit.fair,              -- 6
    awful.layout.suit.fair.horizontal,   -- 7
    awful.layout.suit.spiral,            -- 8
    awful.layout.suit.spiral.dwindle,    -- 9
    awful.layout.suit.max,               -- 10
    awful.layout.suit.max.fullscreen,    -- 11
    awful.layout.suit.floating,          -- 12
}


-- Menu
module.menu = false
function module.main()
    if not module.menu then
        module.menu = box_bl({
        style      = grouped_3d     ,
        item_style = radical.item.style.line_3d ,
        item_height = 18,--48,
        width = 100,        
        border_width = 2,        
        spacing  = 4        
        })        
        local current = function()layout.get(screen)
    screen = screen or capi.mouse.screen
    local t = get_screen(screen).selected_tag
    return tag.getproperty(t, "layout") or layout.suit.floating
end
            
        for i, layout_real in ipairs(module.layouts) do
            local layout_name = awful.layout.getname(layout_real)
            if layout_name then
                module.menu:add_item({
                    icon = beautiful.path.."/layouts/"..layout_name..".png",
                    text = layout_name:gsub("^%l", string.upper), -- Changes the first character of a word to upper case
                    button1 = function()
                        awful.layout.set(module.layouts[module.menu.current_index] or module.layouts[1], awful.screen.focused().selected_tag)
                        common.hide_menu(module.menu)
                    end,
                    selected = (layout_real == current),
                    underlay = i,
                })
            end
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

-- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    local widget_img,img = common.imagebox({icon=beautiful.path.."/layouts/"..awful.layout.getname(awful.layout.get(1))..".png" })
    local function update_layout_icon()
        img:set_image(beautiful.path.."/layouts/"..awful.layout.getname(awful.layout.get(1))..".png")
    end
    local widget_txt,text = common.textbox({ text="LAYOUT", width=60, b1=module.main })

    awful.tag.attached_connect_signal(1, "property::selected", update_layout_icon)
    awful.tag.attached_connect_signal(1, "property::layout",   update_layout_icon)
    layout:add(widget_img)
    layout:add(widget_txt)
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
