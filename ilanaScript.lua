
util.toast("Loaded ilanaScript 0.0.1 DEV")  
util.require_natives(1640181023)
local resource_dir = filesystem.resources_dir()

---\/ spawn npc clone
local new_clone = PED.CLONE_PED(players.user_ped(), true, true, true)
local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -5.0, 0.0, 0.0)
ENTITY.SET_ENTITY_COORDS(new_clone, c.x, c.y, c.z)
TASK.TASK_START_SCENARIO_IN_PLACE(new_clone, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)


MenuA =  menu.action
MenuL = menu.list
MenuR = menu.my_root()



--- roots
Self = MenuL(MenuR, "Self Options")
Vehicle = MenuL(MenuR, "Vehicle Options")
Teleport = MenuL(MenuR, "Teleports")



menu.action(MenuR, 'Restart Script', {}, 'Restarts the script to check for updates', function ()
    util.restart_script()
end)

function Streamptfx(lib)
    STREAMING.REQUEST_NAMED_PTFX_ASSET(lib)
    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(lib) do
        util.yield()
    end
    GRAPHICS.USE_PARTICLE_FX_ASSET(lib)
end

--- end root

---image load

local resources_dir = filesystem.resources_dir() .. '\\ilanaScript\\'
local store_dir = filesystem.store_dir() .. '\\ilanaScript\\'

local jordie_loading = directx.create_texture(resources_dir .. 'jordie.png')
if SCRIPT_MANUAL_START then
    logo_alpha = 0
    logo_alpha_incr = 0.01
    logo_alpha_thread = util.create_thread(function (thr)
        while true do
            logo_alpha = logo_alpha + logo_alpha_incr
            if logo_alpha > 1 then
                logo_alpha = 1
            elseif logo_alpha < 0 then 
                logo_alpha = 0
                util.stop_thread()
            end
            util.yield()
        end
    end)
    logo_thread = util.create_thread(function (thr)
        starttime = os.clock()
        local alpha = 0
        while true do
            directx.draw_texture(jordie_loading, 0.14, 0.14, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, logo_alpha)
            timepassed = os.clock() - starttime
            if timepassed > 3 then
                logo_alpha_incr = -0.01
            end
            if logo_alpha == 0 then
                util.stop_thread()
            end
            util.yield()
        end
    end)
end

---Self Section
menu.action(Self, "Freeze Wanted Level", {}, "Locks your wanted level. Useless since stand already does it.", function()
    menu.trigger_commands("lockwantedlevel")
end)

menu.toggle_loop(Self, "Money Trail", {}, 'Leave a trail of moeney where you step.', function()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local tar1 = ENTITY.GET_ENTITY_COORDS(players.user_ped(), true)
    Streamptfx('scr_exec_ambient_fm')
    if TASK.IS_PED_WALKING(targets) or TASK.IS_PED_RUNNING(targets) or TASK.IS_PED_SPRINTING(targets) then
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('scr_ped_foot_banknotes', tar1.x, tar1.y, tar1.z - 1, 0, 0, 0, 1.0, true, true, true)
    end
    
end)


menu.action(Self, "Boost pad", {}, "Spawns a boost pad in-front of yourself", function() 
    local coords = players.get_position(players.user())
    coords.z = coords.z - 0.2
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local heading = ENTITY.GET_ENTITY_HEADING(player)
    local heading = heading + 80
    local boostpad = entities.create_object(3287988974, coords)
    ENTITY.SET_ENTITY_HEADING(boostpad, heading)
end)





menu.toggle_loop(Self, "Launch nearby vehicles", {"launchveh"}, "Launches nearby vehicles", function(on)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200000000)
			ct = ct + 1
		end
end)
----


--- Teleports

menu.divider(Teleport, "PvP Related Teleports")
menu.action(Teleport, "TP | Golf", {"tpgolf"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1190.8419, 69.60039, 55.741875, 0, 0, 0)
end)
menu.action(Teleport, "TP | Park", {"tppark"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1122.573, -645.76056, 56.80302, 0, 0, 0)
end)
menu.action(Teleport, "TP | Base", {"tpbase"}, "Use this for all your wannabe tryhard needs", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -2626.3645, 3475.1982, 14.982527, 0, 0, 0)
end)
menu.action(Teleport, "TP | LSIA", {"tplsia"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1335.8527, -3044.449, 13.944439, 0, 0, 0)
end)
menu.action(Teleport, "TP | LSIA (1)", {"tp1lsia"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1408.0886, -3288.141, 24.585743, 0, 0, 0)
end)
menu.action(Teleport, "TP | Docks", {"tpdocks"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1020.8491, -3061.2935, 5.901044, 0, 0, 0)
end)
menu.action(Teleport, "TP | Beach", {"tpbeach"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1443.6354, -1460.5477, 2.5691736, 0, 0, 0)
end)
menu.action(Teleport, "TP | Beach (1)", {"tp1beach"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1953.6332, -679.3937, 4.999566, 0, 0, 0)
end)
menu.action(Teleport, "TP | Maze Bank", {"tpmaze"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -75.12867, -819.2142, 326.17514, 0, 0, 0)
end)
menu.action(Teleport, "TP | Shitter Proof", {"tpshitter"}, "Use this to get away from orbital cannons", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -149.28319, -972.3252, 114.13617, 0, 0, 0)
end)
menu.action(Teleport, "TP | Sandy Shores Airfield", {"tpsandy"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1674.1045, 3238.1682, 40.70262, 0, 0, 0)
end)
--
menu.divider(Teleport, "Other Teleports")
menu.action(Teleport, "TP | Box", {"tpbox"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1652.9142, 24.424284, 175.5909, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Vault", {"tpvault"}, "(Shoot the side of the vault door with an Up-n-Atomizer)", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 264.713, 219.9283, 101.68324, 0, 0, 0)
end)
menu.action(Teleport, "TP | Home", {"tphome"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -13.622446, -1992.8419, 6.2512975, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Waterfall", {"tpwater"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -1609.7751, 2081.8792, 72.62493, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Bodyshop", {"tpbodyshop"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 479.96564, -1315.4808, 29.202766, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Racetrack", {"tprace"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1143.2937, 112.5367, 80.96878, 0, 0, 0)
end)
menu.action(Teleport, "TP | Orb Room", {"tporb"}, "Use this if youre already inside your facility", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 330.57593, 4830.176, -59.40196, 0, 0, 0)
end)
menu.action(Teleport, "TP | Wind Farm", {"tpwind"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 2153.1365, 2117.7935, 126.86224, 0, 0, 0)
end)
menu.action(Teleport, "TP | Grapeseed", {"tpseed"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 2434.3704, 4987.2847, 45.98471, 0, 0, 0)
end)
menu.action(Teleport, "TP | Mission End", {"tpmission"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 405.9229, -954.1148, -99.019135, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Far, far away", {"tpfaraway"}, "A long time ago in a galaxy far, far away....", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 124.10113, -1273.1356, 2699.989, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Elysian Island", {"tpelysian"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 489.2595, -3361.0664, 6.0699096, 0, 0, 0)
end)
menu.action(Teleport, "TP | Janitor's House", {"tpjanitor"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -110.20285, -8.6156025, 70.51957, 0, 0, 0)
end)
menu.action(Teleport, "TP | Trevor's Meth Lab", {"tptrevor"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 1391.773, 3608.716, 38.94193, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Character Creation", {"tpcreation"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 402.91605, -998.5699, -99.004074, 0, 0, 0) 
end)
menu.action(Teleport, "TP | Mount Chiliad Jump", {"tpmnt"}, "", function(on_click)
	local me = PLAYER.PLAYER_PED_ID()
	ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, 413.18887, 5572.6694, 779.8468, 0, 0, 0) 
end)

--Veh

menu.action(Vehicle, "Boost Vehicle by 25x", {"VehBoost25"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent, 25)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)



menu.action(Vehicle, "Boost Vehicle by 50x", {"VehBoost50"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent,50)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)




menu.action(Vehicle, "Boost Vehicle by 100x", {"VehBoost100"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent, 100)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)


menu.action(Vehicle, "Boost Vehicle by 200x", {"VehBoost200"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent, 200)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)

menu.action(Vehicle, "Boost Vehicle by 300x", {"VehBoost300"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent, 300)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)

menu.action(Vehicle, "Boost Vehicle by 400x", {"VehBoost400"}, "Give a boost to all nearby players.", function(on_click)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 540
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			ENTITY.SET_ENTITY_MAX_SPEED(ent, maxspeed)
			--VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 200) catapulte
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(ent, 400)
			ct = ct + 1
		end

	--local vehicle = get_vehicle_player_is_in(pId)
	--ENTITY.SET_ENTITY_MAX_SPEED(vehicle, 10000, 10000)
	--VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 1000, 1000)
end)

