extends KinematicBody



export var gravity = Vector3.DOWN * 10
export var speeds = [4.0, 6.0, 10.0]
export var drainSpeeds = [0.01, 0.03, 0.06]
var speedPositions = [Vector2(104,32),Vector2(136,64),Vector2(96,96)]
var speedIndex = 0
var speed : float = 0
export var rot_speed = 0.85

export var batteryLevel : float = 100.0


export var isTowingObject : bool = false


var velocity = Vector3.ZERO

var fetchHud

func _ready():
	
	fetchHud = $Fetch_HUD


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func _process(delta):
	speed = speeds[speedIndex]
	$Fetch_HUD/MovementModeIndicator/Indicator.rect_position = speedPositions[speedIndex]
	$Fetch_HUD/BatteryBar/BatteryPercent.text = str(stepify(batteryLevel,0.1),"%")
	$Fetch_HUD/BatteryBar.value = batteryLevel


func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("increase_speed") && speedIndex < 2 :
		speedIndex += 1
	if Input.is_action_just_pressed("decrease_speed") && speedIndex > 0:
		speedIndex -= 1
	
	if(batteryLevel >= 0):
		if Input.is_action_pressed("forward"):
			velocity += -transform.basis.z * speed
			batteryLevel -= drainSpeeds[speedIndex]
		if Input.is_action_pressed("back"):
			velocity += transform.basis.z * speed
			batteryLevel -= drainSpeeds[speedIndex]
		if Input.is_action_pressed("right"):
			batteryLevel -= drainSpeeds[speedIndex]
			rotate_y(-rot_speed * delta)
		if Input.is_action_pressed("left"):
			batteryLevel -= drainSpeeds[speedIndex]
			rotate_y(rot_speed * delta)
	velocity.y = vy
