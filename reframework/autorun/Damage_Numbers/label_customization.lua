local this = {};

local utils;
local config;
local screen;
local customization_menu;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;

local include_names = {
	current_value = "Current Value",
	max_value = "Max Value"
};

function this.draw(label_name, label)
	local label_changed = false;
	local changed = false;

	if imgui.tree_node(label_name) then
		changed, label.visibility = imgui.checkbox("Visible", label.visibility);
		label_changed = label_changed or changed;
		
		-- add text format

		if imgui.tree_node("Offset") then
			changed, label.offset.x = imgui.drag_float("X", label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			label_changed = label_changed or changed;

			changed, label.offset.y = imgui.drag_float("Y", label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Color") then
			changed, label.color = imgui.color_picker_argb("", label.color, customization_menu.color_picker_flags);
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Shadow") then
			changed, label.shadow.visibility = imgui.checkbox("Visible", label.shadow.visibility);
			label_changed = label_changed or changed;

			if imgui.tree_node("Offset") then
				changed, label.shadow.offset.x = imgui.drag_float("X",
					label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				label_changed = label_changed or changed;

				changed, label.shadow.offset.y = imgui.drag_float("Y",
					label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				label_changed = label_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				changed, label.shadow.color = imgui.color_picker_argb("", label.shadow.color, customization_menu.color_picker_flags);
				label_changed = label_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return label_changed;
end

function this.init_module()
	utils = require("Damage_Numbers.utils");
	config = require("Damage_Numbers.config");
	screen = require("Damage_Numbers.screen");
	customization_menu = require("Damage_Numbers.customization_menu");
end

return this;