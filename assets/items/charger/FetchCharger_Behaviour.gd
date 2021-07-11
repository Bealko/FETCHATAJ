extends Spatial

var fetchIsCharging : bool
var fetchObject

func _ready():
	pass # Replace with function body.





func _on_ChargingArea_body_entered(body):
	if(body.name == "Fetch"):
		print(body.get("batteryLevel"))
		fetchObject = body
		fetchIsCharging = true


func _on_ChargingArea_body_exited(body):
	fetchIsCharging = false


func _process(delta):
	if fetchIsCharging:
		fetchObject.batteryLevel += 5* delta
