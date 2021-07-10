extends Spatial

var isConnected : bool = false
var isTowing : bool = false

var attachedBody
var underBody




func _process(delta):
	
	if isTowing:
			if attachedBody != null:
				var fetchPosToMove = attachedBody.global_transform.origin - self.global_transform.origin
				#attachedBody.linear_velocity = fetchPosToMove.normalized() * 8
				attachedBody.transform.origin.x = get_parent().transform.origin.x
				attachedBody.transform.origin.z = get_parent().transform.origin.z	
				attachedBody.rotation.y = get_parent().rotation.y
				attachedBody.get_node("Base_Collider").disabled = false
	





func _input(event):
	if(Input.is_action_just_pressed("contraption_action_1") && underBody != null):
		get_parent().get_node("Fetch_HUD/PartStatus/TowingSpikes").text = "[.twgSpik=up]"
		isTowing = true
		attachedBody = underBody
		print("Now towing ",attachedBody)
	if(Input.is_action_just_pressed("contraption_action_2") && attachedBody != null):
		get_parent().get_node("Fetch_HUD/PartStatus/TowingSpikes").text = "[.twgSpik=down]"
		attachedBody.get_node("Base_Collider").disabled = true
		print("Now releasing ",attachedBody)
		isTowing = false
		attachedBody = null
		




func _on_Area_body_entered(body):
	print("Now under ",body)
	underBody = body
	
	pass # Replace with function body.


func _on_Area_body_exited(body):
	print("Now exited ",body)
	underBody = null
	pass # Replace with function body.
