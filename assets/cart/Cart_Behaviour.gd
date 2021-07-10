extends RigidBody

var isBeingTowed



func _process(delta):

	if(self.linear_velocity.length() > 1):
		$Wheel0.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel1.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel2.look_at(linear_velocity,Vector3(0, 1, 0))
		$Wheel3.look_at(linear_velocity,Vector3(0, 1, 0))



