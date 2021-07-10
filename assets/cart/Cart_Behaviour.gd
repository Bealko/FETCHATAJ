extends RigidBody

var fetchIsUnder : bool = false
var currentBody

var towing : bool = false

export var items = []

var startWeight

func _ready():
	startWeight = self.weight


func _physics_process(delta):
	if(self.linear_velocity.length() > 1):
		$Wheel0.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel1.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel2.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel3.look_at(linear_velocity,Vector3(0, 1, 0))

	if(towing):
		if (currentBody != null):
			
			var fetchPosToMove = currentBody.global_transform.origin - self.global_transform.origin

			self.linear_velocity = fetchPosToMove.normalized() * 4
			
			self.transform.origin.x = currentBody.transform.origin.x
			self.transform.origin.z = currentBody.transform.origin.z
			
			self.rotation.y = currentBody.rotation.y
			
			for item in items:
				if(item is RigidBody):
					item.global_transform.origin.x = currentBody.global_transform.origin.x 
					item.global_transform.origin.z = currentBody.global_transform.origin.z 
					item.rotation.y = currentBody.rotation.y
					#item.add_force(currentBody.velocity,Vector3.UP)
					#item.sleeping = true
					#item.mode = RigidBody.MODE_STATIC
					#item.transform.

			
			
		elif(!towing):
			self.weight = startWeight
			currentBody = null
	#else:
		#for item in items:
			#if(item is RigidBody):
				#item.sleeping = false
				#item.mode = RigidBody.MODE_RIGID


func _input(event):
	if(fetchIsUnder && Input.is_action_just_pressed("contraption_action_1")):
		print("Pressed")
		towing = !towing

func _on_Item_Area_body_entered(item):
	if(item is RigidBody && item.name != self.name):
		items.append(item)


func _on_Item_Area_body_exited(item):
	items.erase(item)
	



func _on_Fetch_Towing_Area_body_entered(body):
	print(body.name)
	
	if(body.name == "Fetch"):
		print("Fetch is under ", self.name)
		currentBody = body
		fetchIsUnder = true


func _on_Fetch_Towing_Area_body_exited(body):
	if(!towing):
		self.weight = startWeight
		currentBody = null
	
	

