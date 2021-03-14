doors = {}

-- TODO: door textures are currently.... kind-of strange.
-- We need to flip them in a specific way.

local function check_player_priv(def, pos, player)
	def = def or {only_placer_can_open=false}
	if not def.only_placer_can_open then
		return true
	end
	local meta = minetest.get_meta(pos)
	local pn = player:get_player_name()
	return meta:get_string("doors_owner") == pn
end

-- Registers a door
function doors.register_door(name, def)
	def.groups.not_in_creative_inventory = 1

	local box = {{-0.5, -0.5, -0.5, 0.5, 1.5, -0.5+3/16}}

	if not def.selection_box then
		def.selection_box = box
	end

	if not def.sound_close_door then
		def.sound_close_door = "door_close"
	end
	if not def.sound_open_door then
		def.sound_open_door = "door_open"
	end
	
	
	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,

		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end

			local ptu = pointed_thing.under
			local nu = minetest.get_node(ptu)
			if minetest.registered_nodes[nu.name].on_rightclick then
				return minetest.registered_nodes[nu.name].on_rightclick(ptu, nu, placer, itemstack)
			end

			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			if
				not minetest.registered_nodes[minetest.get_node(pt).name].buildable_to or
				not minetest.registered_nodes[minetest.get_node(pt2).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end

			if minetest.is_protected(pt, placer:get_player_name()) or
					minetest.is_protected(pt2, placer:get_player_name()) then
				minetest.record_protection_violation(pt, placer:get_player_name())
				return itemstack
			end

			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end
			if minetest.get_item_group(minetest.get_node(pt3).name, "door") == 0 then
				minetest.set_node(pt, {name=name.."_closed", param2=p2})
			else
				minetest.set_node(pt, {name=name.."_open", param2=p2})
				minetest.get_meta(pt):set_int("right", 1)
			end

			if def.only_placer_can_open then
				local pn = placer:get_player_name()
				local meta = minetest.get_meta(pt)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
			end

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	local tt = def.tiles
	
	local function after_dig_node(pos, name, digger)
		local node = minetest.get_node(pos)
		if node.name == name then
			minetest.node_dig(pos, node, digger)
		end
	end

	local function on_rightclick(pos, replace, closed, params)
		local p2 = minetest.get_node(pos).param2
		p2 = params[p2+1]

		minetest.log(p2)

		minetest.swap_node(pos, {name=replace, param2=p2})

		local snd_1 = def.sound_close_door
		if closed then
			snd_1 = def.sound_open_door 
		end

		minetest.sound_play(snd_1, {pos = pos, gain = 0.3, max_hear_distance = 10})
	end

	minetest.register_node(name.."_closed", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "mesh",
		mesh = "door.obj",
		selection_box = {
			type = "fixed",
			fixed = def.selection_box
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			-- after_dig_node(pos, name.."_top_closed", digger)
		end,
		
		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, name.."_open", true, {3,0,1,2})
			end
		end,
		
		can_dig = check_player_priv,
		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		hardness = def.hardness
	})

	minetest.register_node(name.."_open", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = name,
		drawtype = "mesh",
		mesh = "door.obj",
		selection_box = {
			type = "fixed",
			fixed = def.selection_box
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, name.."_open", digger)
		end,
		
		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, name.."_closed", false, {1,2,3,0})
			end
		end,
		
		can_dig = check_player_priv,
		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		hardness = def.hardness
	})

end

function doors.register_trapdoor(name, def)
	-- Registering one of these is exactly the same as a door, except we don't have a top image.
	-- ~~laziness~~ consistensy!

	local function on_rightclick(pos, replace, closed)
		local p2 = minetest.get_node(pos).param2

		minetest.swap_node(pos, {name=replace, param2=p2})

		local snd_1 = def.sound_close_door
		if closed then
			snd_1 = def.sound_open_door 
		end

		minetest.sound_play(snd_1, {pos = pos, gain = 0.3, max_hear_distance = 10})
	end

	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end

			local ptu = pointed_thing.under
			local nu = minetest.get_node(ptu)
			if minetest.registered_nodes[nu.name].on_rightclick then
				return minetest.registered_nodes[nu.name].on_rightclick(ptu, nu, placer, itemstack)
			end

			local pt = pointed_thing.above
			if
				not minetest.registered_nodes[minetest.get_node(pt).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end

			if minetest.is_protected(pt, placer:get_player_name()) then
				minetest.record_protection_violation(pt, placer:get_player_name())
				return itemstack
			end

			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end

			minetest.set_node(pt, {name=name.."_closed", param2=p2})
			
			if def.only_placer_can_open then
				local pn = placer:get_player_name()
				local meta = minetest.get_meta(pt)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
				meta = minetest.get_meta(pt2)
				meta:set_string("doors_owner", pn)
				meta:set_string("infotext", "Owned by "..pn)
			end

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	minetest.register_node(name.."_closed", {
		tiles = {def.tiles[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = def.drop,
		drawtype = "mesh",
		mesh = "door.obj",
		groups = def.groups,
		
		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, name .. "_open", true)
			end
		end,
		
		can_dig = check_player_priv,
		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		hardness = def.hardness	
	})
	minetest.register_node(name.."_open", {
		tiles = {def.tiles[1] .. "^[transformfy"}, -- transformify
		paramtype = "light",
		paramtype2 = "facedir",
		drop = def.drop,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, 0.5,
				  0.5, 0.5, 0.5 - 3/16 }
			}
		},
		groups = def.groups,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
		end,
		
		on_rightclick = function(pos, node, clicker)
			if check_player_priv(pos, clicker) then
				on_rightclick(pos, name .. "_bottom_closed", false)
			end
		end,
		
		can_dig = check_player_priv,
		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		hardness = def.hardness	
	})
end