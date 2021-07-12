extends KinematicBody


export var path = []
export var path_node = 0

var speed = 2
var velocity : Vector3

var wantsToRepair : bool = false
var saidRepairCue : bool = false
var isRepairing : bool = false

onready var target = get_parent().get_node("Fetch")
export onready var nav = get_parent().get_node("AJHall/Navigation")

onready var repair_cue : AudioStream = preload("res://assets/npc/sounds/engineer_tuu_tanne_korjaan.wav")
onready var repair_ready_cue : AudioStream = preload("res://assets/npc/sounds/engineer_nyt_on_valmista.wav")

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

	if get_node("/root/PlayerVariables").damage > 25 && !saidRepairCue:
		$AudioStreamPlayer.stream = repair_cue
		$AudioStreamPlayer.play()
		saidRepairCue = true
		wantsToRepair = true
	
	if(get_node("/root/PlayerVariables").damage <= 0 && wantsToRepair):
		$AudioStreamPlayer.stream = repair_ready_cue
		$AudioStreamPlayer.play()
		wantsToRepair = false
		saidRepairCue = false
		
	if global_transform.origin.distance_to(target.global_transform.origin) <= 1 && get_node("/root/PlayerVariables").damage > 0 && wantsToRepair:
		isRepairing = true
		$AnimationTree["parameters/conditions/repair"] = true
	if global_transform.origin.distance_to(target.global_transform.origin) > 1 || !wantsToRepair:
		isRepairing = false
		$AnimationTree["parameters/conditions/repair"] = false
	
	
	$AnimationTree.set("parameters/movement/speed/blend_amount",velocity.normalized().length())
	
	if(isRepairing && $repairTimer.is_stopped()):
		$repairTimer.start()
	elif(!isRepairing && !$repairTimer.is_stopped()):
		print("Timer stop.")
		$repairTimer.stop()
	

func move_to(target_position):
	print("Has path")
	path = nav.get_simple_path(global_transform.origin, target_position)
	path_node = 0




func _on_Timer_timeout():
	if get_node("/root/PlayerVariables").damage > 25:
		move_to(target.global_transform.origin)


	
func _on_repairTimer_timeout():
	if(target != null):
		print(self.name, " is repairing!")
		get_node("/root/PlayerVariables").damage -= 5
