extends Node


export var damage : float = 0
export var batteryLevel : float = 100

export var components : int = 0

export var tools : int = 0

export var boxes : int = 0


func reset() -> void:
	damage = 0
	batteryLevel = 100
	components= 0
	tools = 0
	boxes = 0
