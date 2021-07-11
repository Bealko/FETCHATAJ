extends Spatial





func _process(delta):
	rotate_y(5* delta)
	rotate_x(5* delta)

func _on_Area_body_entered(body):
	if(body.name == "Fetch"):
		get_node("/root/PlayerVariables").tools += 1
		queue_free()
		
	pass # Replace with function body.
