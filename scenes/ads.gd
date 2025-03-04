extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GP.Ads.fullscreen_start.connect(_on_ads_start)
	GP.Ads.fullscreen_close.connect(_on_ads_close)
	GP.Ads.rewarded_start.connect(_on_ads_start)
	GP.Ads.rewarded_close.connect(_on_ads_close)
	GP.Ads.rewarded_reward.connect(_on_rewarded_reward)
	GP.Ads.preloader_start.connect(_on_ads_start)
	GP.Ads.preloader_close.connect(_on_ads_close)
	if GP.Ads.is_preloader_playing():
		_on_ads_start()


func _on_fullscreen_pressed() -> void:
	GP.Ads.show_fullscreen(true)

func _on_ads_start() -> void:
	get_tree().set_pause(true)
	AudioServer.set_bus_mute(0, true)
	
func _on_ads_close(_success) -> void:
	get_tree().set_pause(false)
	AudioServer.set_bus_mute(0, false)
	

func _on_rewarded_pressed() -> void:
	GP.Ads.show_rewarded_video(true)

func _on_rewarded_reward() -> void:
	pass
	
func _on_preloader_pressed() -> void:
	GP.Ads.show_preloader()


func _on_banner_pressed() -> void:
	GP.Ads.show_sticky()
	await get_tree().create_timer(10)
	GP.Ads.close_sticky()
