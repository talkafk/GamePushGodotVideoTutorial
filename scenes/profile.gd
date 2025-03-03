extends Control

var player_name:String

func _ready() -> void:
	$SecretCode.text = GP.Player.get_value("secretCode")
	$Name.text = GP.Player.get_player_name()
	player_name = GP.Player.get_value("name")
	GP.Images.uploaded.connect(_on_gp_uploaded)
	load_avatar(GP.Player.get_avatar())
	

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_switch_profile_pressed() -> void:
	GP.Player.login()


func _on_name_text_changed(new_text: String) -> void:
	player_name = new_text


func _on_save_profile_pressed() -> void:
	GP.Player.set_value("name", player_name)
	GP.Player.sync()


func _on_upload_avatar_pressed() -> void:
	GP.Images.upload(["avatar"])


func _on_gp_uploaded(image) -> void:
	var url_avatar = image.src
	url_avatar = GP.Images.resize(url_avatar, 192, 192, true)
	GP.Player.set_value("avatar", url_avatar)
	GP.Player.sync() 
	load_avatar(url_avatar)
	

enum ImageType {PNG, WEBP}
var image_type

func load_avatar(url:String) -> void:
	var reuest := HTTPRequest.new()
	add_child(reuest)
	reuest.request_completed.connect(_on_reuest_complited)
	if "webp" in url:
		image_type = ImageType.WEBP
	elif  "png" in url:
		image_type = ImageType.PNG
	reuest.request(url)
	
	
func _on_reuest_complited(result, response_code, headers, body) -> void:
	if response_code == 200:
		var image = Image.new()
		var err
		match image_type:
			ImageType.PNG:
				err = image.load_png_from_buffer(body)
			ImageType.WEBP:
				err = image.load_webp_from_buffer(body)
		if err == OK:
			var image_text = ImageTexture.create_from_image(image)
			$Avatar.texture = image_text
			
