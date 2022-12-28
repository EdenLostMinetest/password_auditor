-- Minetest Empty Password Audit Mod.
-- license: Apache 2.0
--
-- Bans all player accounts that have no password.
--
-- Ideally, also set "disallow_empty_password = true" in minetest.conf
-- https://forum.minetest.net/viewtopic.php?f=6&t=28537
local r_no_password = 'account has no password'
local r_weak_password = 'account has a weak password'

local function ban_player(pname, reason)
    local e = xban.find_entry(pname, true)
    if e.banned then return end

    minetest.log('warning', '[password_audit] banned for no password: ' .. pname)
    -- xban.ban_player() also ban's their IP, which I don't want to do.
    -- xban.ban_player(pname, 'password_audit', nil, ban_reason)

    local rec = {
        source = 'password_audit',
        time = os.time(),
        expires = nil,
        reason = reason
    }
    table.insert(e.record, rec)
    e.names[pname] = true

    e.reason = rec.reason
    e.time = rec.time
    e.expires = rec.expires
    e.banned = true
end

function do_log(admin_name, text)
    minetest.chat_send_player(admin_name, text)
    minetest.log('warning', text)
end

function do_audit(admin_name)
    do_log(admin_name, 'Starting player account password audit...')

    local count_none = 0
    local count_weak = 0
    local total = 0

    local handler = minetest.get_auth_handler()

    -- Build list of players first (for chat logging the count)
    -- Scanning player list will pause server for several seconds.
    local pnames = {}

    for pname in handler.iterate() do
        total = total + 1
        local auth = handler.get_auth(pname)
        if auth and minetest.check_password_entry(pname, auth.password, "") then
            pnames[pname] = r_no_password
            count_none = count_none + 1
        elseif auth and
            minetest.check_password_entry(pname, auth.password, pname) then
            pnames[pname] = r_weak_password
            count_weak = count_weak + 1
        end
    end

    do_log(admin_name,
           "Total accounts: " .. total .. ", no password: " .. count_none ..
               ", weak password: " .. count_weak)

    if minetest.get_modpath("xban2") ~= nil then
        for pname, reason in pairs(pnames) do ban_player(pname, reason) end
    end

    do_log(admin_name, "Player account audit complete.")
end

minetest.register_chatcommand("xban_no_password", {
    description = "xban all players with no passwords",
    params = "",
    privs = {ban = true},
    func = function(name, params) do_audit(name) end
})
