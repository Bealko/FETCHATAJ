extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	rotate_y(5* delta)
	
	pass


func _on_Area_body_entered(body):
	if(body.name == "Fetch"):
		get_node("/root/PlayerVariables").components += 1
		queue_free()
		
	pass # Replace with function body.
