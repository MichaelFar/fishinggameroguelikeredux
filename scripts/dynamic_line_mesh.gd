extends MeshInstance3D

var startPoint = Vector3.ZERO #For the purposes of a fishing line this should not change
var endPoint = Vector3.ZERO

var objectToFollow = null
var spawnObject = null
var frameCount = 0


func _physics_process(delta):
	if(objectToFollow != null):
		frameCount += 1
		var modified_position = to_local(objectToFollow.lineConnector.global_position)
		startPoint = to_local(spawnObject.global_position)
		#print(modified_position)
		draw_line(modified_position)
		
func draw_line(new_end_point : Vector3):
	clear_line()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	mesh.surface_add_vertex(startPoint)
	endPoint = new_end_point
	
	mesh.surface_add_vertex(endPoint)
	
	mesh.surface_end()
	
func clear_line():
	mesh.clear_surfaces()
