extends Node2D

const BUTTON_SCENE = preload("res://Scenes/States/MainMenu/MainMenuButton.tscn")
# var options = {"story": 3, "freeplay": 1, "options": 2, "donate": 0}
var options = {"story mode": 3, "more games": 1, "options": 2, "gallery": 0}

var optionsOffset = Vector2(50, 220)

var selected = 0
var choseOption = false

func _ready():
	createMenuObjects()
	
	if Conductor.MusicStream.stream.resource_path != "res://Assets/Music/freakyMenu.ogg":
		Conductor.play_song("res://Assets/Music/freakyMenu.ogg", 102, 1)

func _process(_delta):
	if (choseOption):
		return
	
	var optionsSize = options.keys().size()
	var offset = selected - (optionsSize / 2)
	
	var move = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	
	if (move != 0):
		get_node("Sounds/MoveStream").play()
	
	if (selected + move < 0):
		move = 0
		selected = options.size() - 1
	if (selected + move > options.size() - 1):
		move = 0
		selected = 0
	
	selected += move
	
	var i = 0
	for button in $Buttons.get_children():
		if (i == selected):
			button.selected = true
		else:
			button.selected = false
		
		i += 1
	
	if (Input.is_action_just_pressed("confirm")):
		$Timer.start()
		get_node("Sounds/ConfirmStream").play()
		
		var button = $Buttons.get_child(selected)
		button.get_node("AnimationPlayer").play("selected")
		
		var _o = 0
		for otherButtons in $Buttons.get_children():
			if (i != selected):
				otherButtons.visible = false
			_o += 1
			
		choseOption = true
	
func createMenuObjects():
	var i = 0
	for option in options:
		var button = BUTTON_SCENE.instance()
		button.type = options[option]
		button.text = option.to_upper()
		button.position.y = (i * 100)
		button.position.x -= (i * 5)
		button.position += optionsOffset
		
		$Buttons.add_child(button)
		
		i += 1

func option_logic(name):
	match (name):
		"story mode":
			Main.change_scene("res://Scenes/States/WorldMapState.tscn")
		"more games":
			Main.change_scene("res://Scenes/States/FreePlayState.tscn")
		"options":
			Main.change_scene("res://Scenes/States/OptionsState.tscn")
		"gallery":
			Main.change_scene("res://Scenes/States/GalleryState.tscn")
		_:
			Main.change_to_main_menu()

func _on_Timer_timeout():
	option_logic(options.keys()[selected])
