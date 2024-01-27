local this = {};

local utils;
local singletons;
local config;
local customization_menu;
local enemy_handler;
local time;

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

this.player = {};
this.player.position = Vector3f.new(0, 0, 0);
this.player.is_aiming = false;
this.player.is_using_scope = false;

local weapon_gun_core_type_def = sdk.find_type_definition("app.WeaponGunCore");
local on_aim_start_method = weapon_gun_core_type_def:get_method("onAimStart");
local on_aim_end_method = weapon_gun_core_type_def:get_method("onAimEnd");
local update_scope_method = weapon_gun_core_type_def:get_method("updateScope");

function this.on_aim_start(weapon_gun_core)
	this.player.is_aiming = true;
	this.player.is_using_scope = false;
end

function this.on_aim_end(weapon_gun_core)
	this.player.is_aiming = false;
	this.player.is_using_scope = false;
end

function this.on_update_scope(weapon_gun_core)
	this.player.is_using_scope = true;
end

function this.init_module()
	sdk.hook(on_aim_start_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_aim_start(weapon_gun_core)

	end, function(retval)
		return retval;
	end);

	sdk.hook(on_aim_end_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_aim_end(weapon_gun_core)

	end, function(retval)
		return retval;
	end);

	sdk.hook(update_scope_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_update_scope(weapon_gun_core)

	end, function(retval)
		return retval;
	end);
end

return this;