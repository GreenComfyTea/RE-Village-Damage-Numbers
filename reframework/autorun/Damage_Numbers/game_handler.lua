local this = {};

local singletons;
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

this.game = {};
this.game.is_cutscene_playing = false;
this.game.is_paused = false;
this.game.is_mercenaries = false;

local content_timer_type_def = sdk.find_type_definition("app.ContentTimer");
local on_pause_method = content_timer_type_def:get_method("onPause");

local event_system_app_type_def = sdk.find_type_definition("app.EventSystemApp");
local is_running_event_method = event_system_app_type_def:get_method("isRunningEvent(System.Boolean)");

function this.update_is_cutscene()
	local event_system_app = singletons.event_system_app;

	if event_system_app == nil then
		customization_menu.status = "[gui.update_is_cutscene] No Event System App";
        return;
    end

	local is_player_event_playing = is_running_event_method:call(event_system_app, true);
	local is_event_playing = is_running_event_method:call(event_system_app, false);

	if is_player_event_playing == nil then
		customization_menu.status = "[gui.update_is_cutscene] No Is Player Event Playing";
		is_player_event_playing = false;
	end

	if is_event_playing == nil then
		customization_menu.status = "[gui.update_is_cutscene] No Is Event Playing";
		is_event_playing = false;
	end

	this.game.is_cutscene_playing = is_player_event_playing or is_event_playing;
end

function this.update_is_mercenaries()
	this.game.is_mercenaries = singletons.rogue_enemy_health_holder ~= nil;
end

function this.update()
	this.update_is_cutscene();
	this.update_is_mercenaries();
end

function this.on_pause(is_paused)
	if is_paused ~= nil then
		this.game.is_paused = is_paused;
	end
end


function this.init_module()
	singletons = require("Damage_Numbers.singletons");
	customization_menu = require("Damage_Numbers.customization_menu");

	sdk.hook(on_pause_method, function(args)

		local is_paused = (sdk.to_int64(args[3]) & 1) == 1;
		this.on_pause(is_paused);

	end, function(retval)
		return retval;
	end);
end

return this;