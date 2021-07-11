extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var path = []
export var path_node = 0

var speed = 2
var velocity : Vector3
var attack : bool = false

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
			look_at(2 * global_transform.origin - target.global_transform.origin,Vector3.UP)
			velocity = move_and_slide(direction.normalized() * speed,Vector3.UP)
	
	
	if global_transform.origin.distance_to(target.global_transform.origin) <= 1:
		attack = true
		$AnimationTree["parameters/conditions/kick"] = true
	elif global_transform.origin.distance_to(target.global_transform.origin) > 1:
		attack = false
		$AnimationTree["parameters/conditions/kick"] = false
	if(velocity.length() > 1):
		$AnimationTree.set("parameters/velocity/blend_amount",1)
	
	if(attack && $attackTimer.is_stopped()):
		$attackTimer.start()
	elif(!attack && !$attackTimer.is_stopped()):
		print("Timer stop.")
		$attackTimer.stop()
	
	
func move_to(target_position):
	print("Has path")
	path = nav.get_simple_path(global_transform.origin, target_position)
	path_node = 0




func _on_Timer_timeout():
	move_to(target.global_transform.origin)
	
#	if target != null:
#		move_to(target.global_transform.origin)


func _on_Area_body_entered(body):
	if body.name == "Fetch":
		$AudioStreamPlayer3D.stream = sound_angry
		$AudioStreamPlayer3D.play()
	pass # Replace with function body.








func _on_Area_body_exited(body):
	if body.name == "Fetch":
		$AudioStreamPlayer3D.stream = sound_relief
		$AudioStreamPlayer3D.play()
	


func _on_attackTimer_timeout():
	if(target != null):
		print("Attacking!")
		target.batteryLevel -= 5
