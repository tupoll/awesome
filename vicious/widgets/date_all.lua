---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
--  * (c) 2009, Lucas de Vries <lucas@glacicle.com>
---------------------------------------------------

-- {{{ Grab environment
local setmetatable = setmetatable
local os = {
    date = os.date,
    time = os.time
}
-- }}}


-- Date: provides access to os.date with optional time formatting
-- vicious.widgets.date
local date_all = {}


-- {{{ Date widget type
local function worker(format, warg)
    return os.date(format or nil, warg and os.time()+warg or nil)
end
-- }}}

return setmetatable(date_all, { __call = function(_, ...) return worker(...) end })
