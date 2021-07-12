extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



func _on_NewGame_Button_pressed():
	get_node("/root/PlayerVariables").call("reset")
	self.call_deferred("free")
	get_tree().change_scene("res://levels/hall/HallLevel.tscn")


func _on_ExitGame_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.
