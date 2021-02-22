bobcraft_crafting = {}

bobcraft_crafting.do_tool_recipes = function(tier, material)
	-- ##
	-- #:
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{material, "bobcraft_items:stick"},
			{"",       "bobcraft_items:stick"}
		}
	})
	--  ##
	--  :#
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{"bobcraft_items:stick", material},
			{"bobcraft_items:stick", ""}
		}
	})
	-- ###
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_pickaxe",
		recipe = {
			{material, material, material},
			{"",       "bobcraft_items:stick", ""},
			{"",       "bobcraft_items:stick", ""}
		}
	})
	--  #
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_shovel",
		recipe = {
			{material},
			{"bobcraft_items:stick"},
			{"bobcraft_items:stick"}
		}
	})
	--  #
	--  #
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_sword",
		recipe = {
			{material},
			{material},
			{"bobcraft_items:stick"}
		}
	})
end

-- # = log
-----
-- #
minetest.register_craft({
	output = "bobcraft_blocks:planks 4",
	recipe = {
		{"bobcraft_blocks:log"}
	}
})

-- # = wood
-----
-- #
-- #
minetest.register_craft({
	output = "bobcraft_items:stick 4",
	recipe = {
		{"group:crafting_wood"},
		{"group:crafting_wood"}
	}
})

-- # = coal, : = stick
-----
-- #
-- :
minetest.register_craft({
	output = "bobcraft_blocks:torch 4",
	recipe = {
		{"group:crafting_coal_like"},
		{"bobcraft_items:stick"}
	}
})

-- # = stone
-----
-- ###
-- # #
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:furnace",
	recipe = {
		{"group:crafting_stone", "group:crafting_stone", "group:crafting_stone"},
		{"group:crafting_stone", "", "group:crafting_stone"},
		{"group:crafting_stone", "group:crafting_stone", "group:crafting_stone"},
	}
})

-- paper
-- # = sugarcane
-----
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:paper 3",
	recipe = {
		{"bobcraft_blocks:sugarcane","bobcraft_blocks:sugarcane","bobcraft_blocks:sugarcane",},
	}
})

-- book
-- # = paper
-----
-- #
-- #
-- #
minetest.register_craft({
	output = "bobcraft_blocks:book", -- No leather = suitable for vegans!
	recipe = {
		{"bobcraft_items:paper",}
		{"bobcraft_items:paper",}
		{"bobcraft_items:paper",}
	}
})

-- fence
-- # = stick
-----
-- ###
-- ###

-- netherfence
-- # = nether brick
-----
-- ###
-- ###

-- fence gate
-- # = stick, w = wood
-----
-- #w#
-- #w#

-- jukebox
-- # = wood, x = diamond
-----
-- ###
-- #x#
-- ###

-- noteblock
-- # = wood, x = redstone
-----
-- ###
-- #x#
-- ###

-- bookshelf
-- # = wood, x = book
-----
-- ###
-- xxx
-- ###

-- snow block
-- # = snowball
-----
-- ##
-- ##

-- clay block
-- # = clay
-----
-- ##
-- ##

-- brick block
-- # = brick
-----
-- ##
-- ##

-- glowstone
-- # = glowstone dust
-----
-- ##
-- ##

-- wool (white) block
-- # = wool
-----
-- ##
-- ##

-- tnt
-- # = sand, x = gunpowder
-----
-- x#x
-- #x#
-- x#x

-- stair
-- note; stairs will probably be generated, so this recipe applies to all stairs
-- # = material
-----
-- #
-- ##
-- ###

-- slab
-- note; slabs will probably be generated with stairs, so this recipe applies to all slabs
-- # = material
-----
-- ###

-- ladder
-- # = stick
-----
-- # #
-- ###
-- # #

-- wooden door
-- # = wood
-----
-- ##
-- ##
-- ##

-- trapdoor
-- # = wood
-----
-- ###
-- ###

-- iron door
-- # = iron
-----
-- ##
-- ##
-- ##

-- sign
-- # = wood, x = stick
-----
-- ###
-- ###
--  x

-- cake
-- # = milk, x = sugar, e = egg, w = wheat
-----
-- ###
-- xex
-- www

-- sugar
-- # = sugarcane
-----
-- #

-- bowl
-- # = wood
-----
-- # #
--  #

-- glass bottle
-- # = glass
-----
-- # #
--  #

-- rail
-- # = stick, x = iron
-----
-- x x
-- x#x
-- x x

-- powered rail
-- # = stick, x = iron, r = greendust
-----
-- x x
-- x#x
-- xrx

-- detector rail
-- # = stick, x = iron, r = plate
-----
-- x x
-- x#x
-- xrx

-- minecart
-- # = iron
-----
-- # #
-- ###

-- cauldron
-- # = stick, x = iron
-----
-- # #
-- # #
-- ###

-- brewing stand
-- # = stone, b = blaze rod
-----
--  b
-- ###

-- jack-o-lantern
-- (shapeless)
-- # = pumpkin, a = torch
-----

-- minecart with chest
-- (shapeless)
-- # = minecart, a = chest
-----

-- minecart with furnace
-- (shapeless)
-- # = minecart, a = furnace
-----

-- boat
-- # = planks
-----
-- # #
-- ###

-- bucket
-- # = iron
-----
-- # #
--  #

-- flint and steel
-- (shapeless)
-- # = iron, x = flint
-----

-- bread
-- # = wheat
-----
-- ###

-- fishing rod
-- # = sticks, ~ = string
-----
--   #
--  #~
-- # ~

-- boat
-- # = planks
-----
-- # #
-- ###

-- painting
-- # = stick, x = wool
-----
-- ###
-- #x#
-- ###

-- gold apple
-- # = gold nugget, a = apple
-----
-- ###
-- #a#
-- ###

-- lever
-- # = stone, / = stick
-----
-- /
-- #

-- greendust torch
-- # = greendust, : = stick
-----
-- #
-- :

-- greendust repeater
-- # = stone, / = greendust, : = greendust torch
-----
-- :::
-- #/#

-- clock
-- # = gold ingot, r = greendust
-----
--  #
-- #r#
--  #

-- compass
-- # = iron, r = greendust
-----
--  #
-- #r#
--  #

-- map
-- # = paper, x = compass
-----
-- ###
-- #x#
-- ###

-- button
-- # = stone
-----
-- #

-- pressure plate, stone
-- # = stone
-----
-- ##

-- pressure plate, wood
-- # = wood
-----
-- ##

-- dispenser
-- # = stone, b = bow, r = greendust
-----
-- ###
-- #b#
-- #r#

-- piston
-- # = stone, i = iron, r = greendust, p = planks
-----
-- ppp
-- #i#
-- #r#

-- sticky piston
-- # = piston, s = slimeball
-----
-- s
-- #

-- bed
-- # = wood, w = wool (any colour)
-----
-- www
-- ###

-- all-seeing eye (eye of ender)
-- (shapeless)
-- a = eye, b = blazepowder
-----

-- fireball
-- (shapeless)
-- a = gunpowder, b = blazepowder, c = coal
-----

-- Shapeless wool dying
-- TODO: should we move this to wool.lua?
for i, colour in ipairs(dyes.colour_names) do
	minetest.register_craft({
		type = "shapeless",
		output = "bobcraft_blocks:wool_"..colour,
		recipe = {
			dyes.items[colour],
			"bobcraft_blocks:wool_white"
		}
	})
end

local modpath = minetest.get_modpath("bobcraft_crafting")
dofile(modpath.."/cooking.lua")