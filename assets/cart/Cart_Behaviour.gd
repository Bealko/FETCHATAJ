extends RigidBody

#var currentBody
#
#export var isBeingTowed : bool = false
#export var fetchIsUnder : bool = false
#
#export var items = []
#
#var startWeight
#
#
func _process(delta):

	if(self.linear_velocity.length() > 1):
		$Wheel0.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel1.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel2.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel3.look_at(linear_velocity,Vector3(0, 1, 0))

#	if(isBeingTowed ):
#		if currentBody != null && !currentBody.get("isOccupied"):
#			currentBody.isOccupied = true
#
#	if(currentBody != null):
#		if(currentBody.get("isOccupied")):
#			var fetchPosToMove = currentBody.global_transform.origin - self.global_transform.origin
#			self.linear_velocity = fetchPosToMove.normalized() * 8
#			self.transform.origin.x = currentBody.transform.origin.x
#			self.transform.origin.z = currentBody.transform.origin.z	
#			self.rotation.y = currentBody.rotation.y
#
#			for item in items:
#				if(item is RigidBody):
#					item.global_transform.origin.x = currentBody.global_transform.origin.x 
#					item.global_transform.origin.z = currentBody.global_transform.origin.z 
#					item.rotation.y = currentBody.rotation.y
#
#
#
#
#
#func _input(event):
#	if(fetchIsUnder && Input.is_action_just_pressed("contraption_action_1")):
#		isBeingTowed = true
#		print("isBeingTowed ",isBeingTowed)
#	if(Input.is_action_just_pressed("contraption_action_2") && currentBody != null):
#		if(currentBody.get("isOccupied")):
#			isBeingTowed = false
#			currentBody.isOccupied = false
#
#func _on_Item_Area_body_entered(item):
#	if(item is RigidBody && item.name != self.name):
#		items.append(item)
#
#
#func _on_Item_Area_body_exited(item):
#	items.erase(item)
#
#
#
#
#func _on_Fetch_Towing_Area_body_entered(body):
#	if(body.name == "Fetch"):
#		currentBody = body
#		if(currentBody != null):
#			if(!currentBody.get("isOccupied")):
#				fetchIsUnder = true
#				print("Fetch is under ", self.name)
#
#
#
#func _on_Fetch_Towing_Area_body_exited(body):
#	if(body.name == "Fetch"):
#		fetchIsUnder = false
#		isBeingTowed = false
#		currentBody = null
#
#
#

