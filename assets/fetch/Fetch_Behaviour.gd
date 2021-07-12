extends KinematicBody



export var gravity = Vector3.DOWN * 10
export var speeds = [4.0, 6.0, 10.0]
export var drainSpeeds = [0.01, 0.03, 0.06]

onready var motorAudioPlayer = $MotorSounds
onready var indicationAudioPlayer = $IndicationSounds
var speedPositions = [Vector2(104,32),Vector2(136,64),Vector2(96,96)]
var speedIndex = 0
var speed : float = 0
export var rot_speed = 0.85



export var isOccupied : bool = false
var rotating : bool = false

var velocity = Vector3.ZERO

var fetchHud

onready var lowBatterySound = preload("res://assets/fetch/sound/low_battery.wav")



func _ready() -> void:
	fetchHud = $Fetch_HUD


# Called when the node enters the scene tree for the first time.
func _physics_process(delta) -> void:
	velocity += gravity * delta
	get_input(delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func _process(delta) -> void:
	
	
	speed = speeds[speedIndex]
	motorAudioPlayer.pitch_scale = speeds[speedIndex]/2

	checkBatteryLevel()
	updateHUD()
	
	if(velocity.length() > 1):
		motorAudioPlayer.play()
	elif(velocity.length() < 1):
		motorAudioPlayer.stop()

func get_position():
	return global_transform.origin


func checkBatteryLevel() -> void:
	
	if get_node("/root/PlayerVariables").batteryLevel >= 100:
		get_node("/root/PlayerVariables").batteryLevel = 100
	
	if get_node("/root/PlayerVariables").batteryLevel <= 0 || get_node("/root/PlayerVariables").damage >= 100:
		self.call_deferred("free")
		get_tree().change_scene("res://assets/hud/GameOverHUD.tscn")
	
	if get_node("/root/PlayerVariables").batteryLevel < 25:
		if !indicationAudioPlayer.is_playing():
			indicationAudioPlayer.stream = lowBatterySound
			indicationAudioPlayer.play()
	if get_node("/root/PlayerVariables").batteryLevel > 25:
		if indicationAudioPlayer.is_playing():
			indicationAudioPlayer.stop()


func updateHUD():
	$Fetch_HUD/MovementModeIndicator/Indicator.rect_position = speedPositions[speedIndex]
	$Fetch_HUD/BatteryBar/BatteryPercent.text = str(stepify(get_node("/root/PlayerVariables").batteryLevel, 0.1),"%")
	$Fetch_HUD/BatteryBar.value = get_node("/root/PlayerVariables").batteryLevel
	$Fetch_HUD/InternalDamage/DamagePercent.text = str(stepify(get_node("/root/PlayerVariables").damage, 0.1),"%")
	$Fetch_HUD/InternalDamage.value = get_node("/root/PlayerVariables").damage
	
	
	$Fetch_HUD/StorageElement/terminalBlocks.text = str("[.comBlocks=",get_node("/root/PlayerVariables").components,"]")
	$Fetch_HUD/StorageElement/lostTools.text = str("[.lostTools=",get_node("/root/PlayerVariables").tools,"]")






func get_input(delta) -> void:
	var vy = velocity.y
	velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("increase_speed") && speedIndex < 2 :
		speedIndex += 1
	if Input.is_action_just_pressed("decrease_speed") && speedIndex > 0:
		speedIndex -= 1
	
	if(get_node("/root/PlayerVariables").batteryLevel >= 0):
		if Input.is_action_pressed("forward"):
			velocity += -transform.basis.z * speed
			get_node("/root/PlayerVariables").batteryLevel -= drainSpeeds[speedIndex]
			
		if Input.is_action_pressed("back"):
			velocity += transform.basis.z * speed
			get_node("/root/PlayerVariables").batteryLevel -= drainSpeeds[speedIndex]
			
		if Input.is_action_pressed("right"):
			get_node("/root/PlayerVariables").batteryLevel -= 0.01
			rotate_y(-speed / 2 * delta)
			
		if Input.is_action_pressed("left"):
			get_node("/root/PlayerVariables").batteryLevel -= 0.01
			rotate_y(speed/ 2 * delta)
			
	velocity.y = vy

