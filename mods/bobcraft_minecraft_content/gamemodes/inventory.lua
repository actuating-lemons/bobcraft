-- ""inspiration""" taken from the minetest_game's creative_mode mod
local creative = {}

local inventories = {}
local creative_cache = {}

function creative.cache(items)
	creative_cache[items] = {}
	local i_cache = creative_cache[items]

	for name, def in pairs(items) do
		if def.groups.not_in_creative_inventory ~= 1 and
				def.description and def.description ~= "" then
			i_cache[name] = def
		end
	end
	table.sort(i_cache)
	return i_cache
end

function creative.init_inventory(player)
	local player_name = player:get_player_name()
	inventories[player_name] = {
		size = 0,
		start_i = 0,
	}

	minetest.create_detached_inventory("creative_"..player_name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player2)
			return count
		end,
	}
	, player_name)
end

function creative.update_inventory(player_name, content)

	local inv = inventories[player_name] or
				creative.init_inventory(minetest.get_player_by_name(player_name))
	local player_inv = minetest.get_inventory({type = "detached", name = "creative_" .. player_name})
	
	local items = creative_cache[content] or creative.cache(content)

	player_inv:set_size("main", #items)
	player_inv:set_list("main", items)
	inv.size = #items

end

function creative.register_tab(name, title, items)
	sfinv.register_page("creative:" .. name, {
		title = title,
		is_in_nav = function(self, player, context)
			return minetest.is_creative_enabled(player:get_player_name())
		end,
		get = function(self, player, context)
			local player_name = player:get_player_name()
			
			creative.update_inventory(player_name, items)

			local inv = inventories[player_name]

			return sfinv.make_formspec(player, context,
			"list[detached:creative_" .. player_name .. ";main;0,0;8,8;]" ..
			"field[0.25,8.5;8,1;search;;]" ..
			"", false)
		end,
		on_enter = function(self, player, context)
			local player_name = player:get_player_name()
			local inv = inventories[player_name]
			if inv then
				inv.start_i = 0
			end
		end,
		on_player_receive_fields = function(self, player, context, fields)
			local player_name = player:get_player_name()
			local inv = inventories[player_name]
			assert(inv)
		end
	})
end

creative.register_tab("list", "Creative List", minetest.registered_items)

function sfinv.get_homepage_name(player)
	return "creative:list"
end