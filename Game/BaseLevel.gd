extends Node2D

export (String) var down_floor
export (String) var up_floor

var has_the_engine = false
var engine_posible_positions = []
onready var engine_scene = preload("res://Game/Engine.tscn")

var path_speed = 250
onready var enemies_node = $Enemies

var rng = RandomNumberGenerator.new()

var game_ended
var won
var engine_instance = null 

var killed_enemies = 0
	
var total_enemies
var unlock_stairs = false

func _ready():
	total_enemies = $Enemies.get_child_count()
	print("total enemies ", total_enemies)
	
	Sound.play("music")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if has_the_engine:
		engine_instance = engine_scene.instance()
		rng.randomize()
		print("len")
		print(len(engine_posible_positions))
		var ind = rng.randi_range(0,len(engine_posible_positions)-1)		
		engine_instance.global_position = engine_posible_positions[ind]
		get_tree().current_scene.add_child(engine_instance)
	
func go_down_floor():
	get_tree().change_scene(down_floor)

func go_up_floor():
	get_tree().change_scene(up_floor)

func _physics_process(delta):
	pass

func _process(delta):
	killed_enemies = total_enemies - $Enemies.get_child_count()
	#if killed_enemies == total_enemies:
	if	$Enemies.get_child_count() == 0:
		unlock_stairs = true
		get_node("StairUp").unlocked = true
		get_node("StairDown").unlocked = true
	
	if not $Player:
		if engine_instance: 
			if not engine_instance.killed:
				game_ended = true
				$CanvasLayer/Dead.visible = true
		else:
			game_ended = true
			$CanvasLayer/Dead.visible = true
	if engine_instance:
		if engine_instance.killed:
			game_ended = true
			#$Player.queue_free()
			$CanvasLayer/Win.visible = true
	
	
func _input(event):
	#Escape for quit
	if (event is InputEventKey):
		if(event.is_pressed()):
			if(event.scancode == KEY_ESCAPE):
				get_tree().quit()
			if event.scancode == KEY_ENTER && game_ended:
				get_tree().change_scene("res://Menu.tscn")
			if event.scancode == KEY_E:
				print("killed enemies ", killed_enemies)
				print("total enemies ", $Enemies.get_child_count())
				#print("killed enemies ", killed_enemies)
				
			
