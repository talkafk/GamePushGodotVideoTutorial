extends Control

var score:int:
	set(value):
		$kliker/Score.text = str(value)
		GP.Player.set_value("score", value)
		GP.Player.sync()
		score = value

var gold:int:
	set(value):
		$kliker2/Gold.text = str(value)
		GP.Player.set_value("gold", value)
		GP.Player.sync()
		gold = value
		
var data:Dictionary

var vip:bool:
	set(value):
		$Crown.visible = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = GP.Player.get_value("score")
	gold = GP.Player.get_value("gold")
	var _data = GP.Player.get_value("data")
	if _data:
		data = JSON.parse_string(_data)
	$kliker3/Attack.text = str(data["Attack"])
	$kliker4/Defense.text = str(data["Defense"])
	GP.Payments.purchased.connect(_on_gp_puchased)
	GP.Payments.subscribed.connect(_on_gp_subscribed)
	if GP.Payments.has(ID_VIP):
		$Subsciption/TextureRect.show()

func _on__score_pressed() -> void:
	if GP.Player.get_value('energy') > 0:
		GP.Player.add_value('energy', -1)
		score += 1

func _on__gold_pressed() -> void:
	gold += 1

func _on__attack_pressed() -> void:
	data["Attack"] = data.get("Attack", 0) + 1
	$kliker3/Attack.text = str(data["Attack"])
	GP.Player.set_value("data", JSON.stringify(data))
	GP.Player.sync()

func _on__defense_pressed() -> void:
	data["Defense"] = data.get("Defense", 0) + 1
	$kliker4/Defense.text = str(data["Defense"])
	GP.Player.set_value("data", JSON.stringify(data))
	GP.Player.sync()


func _on_leaderboard_score_pressed() -> void:
	GP.Leaderboard.open(["score"], "DESC", 50, [], [], "last", 2)


func _on_leaderboard_gold_pressed() -> void:
	GP.Leaderboard.open(["gold"], "DESC", 50, [], [], "last", 2)


func _on_purchase_pressed() -> void:
	GP.Payments.purchase(8710)


func _on_gp_puchased(data:Array) -> void:
	if data[1].product_id == 8710:
		score += 10
		GP.Payments.consume(8710)
		

const ID_VIP = 8713

func _on_subscibe_pressed():
	GP.Payments.subscribe(ID_VIP) 


func _on_gp_subscribed(data):
	if data[1].product_id == ID_VIP:
		$Subsciption/TextureRect.show()


func _on_unsubscibe_pressed():
	GP.Payments.unsubscribe(ID_VIP)


func update_energy_ui() -> void:
	$Energy/ProgressBar.value = GP.Player.get_value("energy")
	$Energy/ProgressBar.max_value = GP.Player.get_value("energy:max")
	$Energy/ProgressBar/Label.text = str(GP.Player.get_value("energy")) +"/" + str(GP.Player.get_value("energy:max")) +\
	"(" + str(GP.Player.get_value('energy:secondsLeftTotal')) + "s)"


func _on_update_ui_timeout() -> void:
	update_energy_ui()


func _on_plus_one_pressed() -> void:
	GP.Player.add_value('energy', 1)


func _on_plus_one_max_pressed() -> void:
	GP.Player.add_value('energy:max', 1)


func _on_refill_pressed() -> void:
	GP.Player.set_value('energy', GP.Player.get_max_value("energy"))
	GP.Player.sync()
	 
