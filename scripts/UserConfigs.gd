extends Node

#region 🔈 audio configs
var audio_master_volume : float = 0.8
var audio_music_volume : float = 0.6
var audio_ambience_volume : float = 0.6
var audio_sounds_volume : float = 1.0
var audio_voice_volume : float = 1.0
var audio_ui_volume : float = 0.6
#endregion
#region 🖼️ graphics
var graphics_resolution : int = 0
var graphics_fullscreen : bool = false
var graphics_msaa : bool = false
enum PARTICLE_COUNT{NONE, FEW, MANY}
var graphics_particle_amount : PARTICLE_COUNT = PARTICLE_COUNT.MANY
#endregion
#region 💬 text settings
var text_scroll_speed : float = 60.0 #60 chars per second
var text_skip_speed : float = 800.0 #800 chars per second
#endregion

var configs_loaded : bool = false
@warning_ignore("unused_signal")
signal finish_loading_configs
signal configs_updated

func _ready() -> void:
	load_configs()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_configs()


func load_configs() -> void:
	var configs = ConfigFile.new()
	var err = configs.load("user://user_settings.cfg")

	if err != OK:
		return

	for section in configs.get_sections():
		for key in configs.get_section_keys(section):
			set(section.to_lower()+"_"+key, configs.get_value(section, key))
	print("Loaded configs.")
	configs_loaded = true
	apply_configs()


func save_configs() -> void:
	var configs = ConfigFile.new()

	for property in get_script().get_script_property_list():
		if property["usage"] == 128:
			continue
		var section = (property["name"] as String).split("_", 0)
		if section[0] == "configs":
			continue
		var key = (property["name"] as String).replace(section[0]+"_", "")
		configs.set_value(section[0].to_upper(), key, get(property["name"]))
#		print("Set section %s key %s with value %s" % [section, key, get(property["name"])])
	configs.save("user://user_settings.cfg")
	print("Finished saving configs.")
	apply_configs()


func getSettingsDict() -> Dictionary:
	var output : Dictionary = {}
	for property in get_script().get_script_property_list():
		if property["usage"] == 128:
			continue
		var section = (property["name"] as String).split("_", 0)
		if section[0] == "configs":
			continue
		output[property["name"]] = get(property["name"])
	return output


func apply_configs() -> void:
	AudioServer.set_bus_volume_db(0, audio_master_volume)
	AudioServer.set_bus_volume_db(1, audio_music_volume)
	AudioServer.set_bus_volume_db(2, audio_ambience_volume)
	AudioServer.set_bus_volume_db(3, audio_sounds_volume)
	AudioServer.set_bus_volume_db(4, audio_ui_volume)
	AudioServer.set_bus_volume_db(5, audio_voice_volume)
	configs_updated.emit()
