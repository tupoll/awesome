
local wibox     = require("wibox")
local beautiful = require("beautiful")
local radical   = require("radical")
local memory  = require("compact.memory.memory_linux")
local common    = require("compact.common.helpers1")
local volume  = require("compact.mixer.oss")

local module = {}

local mixer = os.execute("mixer vol")

module.OPEN = "mixer vol"
module.PATHS =  {  

    { "",                 "mixer vol  0"  ,      "audio-volume-muted.png", },
    { "*",                "mixer vol  10"  ,     " ",                      },
    { "** ",              "mixer vol  20"  ,     " ",                      },
    { "*** ",             "mixer vol  30"  ,     " ",                      },
    { "**** ",            "mixer vol  40"  ,     " ",                      },
    { "***** ",           "mixer vol  50"  ,     " ",                      },
    { "****** ",          "mixer vol  60"  ,     " ",                      },
    { "******* ",         "mixer vol  70"  ,     " ",                      },
    { "******** ",        "mixer vol  80"  ,     " ",                      },
    { "********* ",       "mixer vol  90"  ,     " ",                      },
    { "**********",       "mixer vol  100" ,     " ",                      }
    
}

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.box({
         
        })
        local tags = awful.tag.gettags(1)
        for _,t in ipairs(module.PATHS) do
            module.menu:add_item({
                tooltip = t[2],
                button1 = function()
                    awful.util.spawn(module.OPEN.." "..t[2])
                    common.hide_menu(module.menu)
                end,
                text=t[1], icon=beautiful.path.."/mixer/"..t[3] 
            })
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
    layout:add(volume())   
    layout:add(common.textbox({text="", width=5, b1=module.main }))   
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })

