extends Control

@onready var health_bar = $ProgressBar
@export var player_path: NodePath
var player

func _ready():
	if player_path:
		player = get_node(player_path)

func _process(delta):
	if player:
		health_bar.value = player.current_health
		health_bar.max_value = player.max_health
