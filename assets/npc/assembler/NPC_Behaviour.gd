extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var path = []
export var path_node = 0

var speed = 2
var velocity : Vector3
var attack : bool = false
var is_angry : bool = false


onready var target = get_parent().get_node("Fetch")
export onready var nav = get_parent().get_node("AJHall/Navigation")



onready var sound_angry : AudioStream = preload("res://assets/npc/sounds/npc_taas_tuo_robotti.wav")
onready var sound_relief : AudioStream = preload("res://assets/npc/sounds/npc_onneks_se_lahti.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta) -> void:
	
	if path_node < path.size():
		var direction = (path[path_node] - self.global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			look_at(2 * global_transform.origin - Vector3(path[path_node].x,0,path[path_node].z),Vector3.UP)
			velocity = move_and_slide(direction.normalized() * speed,Vector3.UP)
	
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	
	
	if global_transform.origin.distance_to(target.global_transform.origin) <= 1:
		attack = true
		$AnimationTree["parameters/conditions/kick"] = true
	elif global_transform.origin.distance_to(target.global_transform.origin) > 1:
		attack = false
		$AnimationTree["parameters/conditions/kick"] = false
	
	$AnimationTree.set("parameters/movement/speed/blend_amount",velocity.normalized().length())

	
	if(attack && $attackTimer.is_stopped()):
		print("Attack Timer start.")
		$attackTimer.start()
	elif(!attack && !$attackTimer.is_stopped()):
		print("Attack Timer stop.")
		$attackTimer.stop()
	
	if(is_angry && $Timer.is_stopped()):
		print("Navigation Timer start.")
		$Timer.start()
	elif(!is_angry && !$Timer.is_stopped()):
		print("Navigation Timer stop.")
		$Timer.stop()
		path_node = 0
		
	
	
	if global_transform.origin.distance_to(target.global_transform.origin) <= 10 && !is_angry:
		$AudioStreamPlayer.stream = sound_angry
		$AudioStreamPlayer.play()
		is_angry = true
	
	if global_transform.origin.distance_to(target.global_transform.origin) >= 20 && is_angry:
		$AudioStreamPlayer.stream = sound_relief
		$AudioStreamPlayer.play()
		is_angry = false
	

func move_to(target_position):
	print(self.name, " has path")
	path = nav.get_simple_path(global_transform.origin, target_position)
	path_node = 0




func _on_Timer_timeout():
	move_to(target.global_transform.origin)
	pass


	
func _on_attackTimer_timeout():
	if(target != null):
		print(self.name, " is attacking!")
		get_node("/root/PlayerVariables").damage += 5
