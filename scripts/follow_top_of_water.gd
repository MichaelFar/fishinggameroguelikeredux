extends RigidBody3D

#Sets Y position 

@export var waterPlane : MeshInstance3D

@export var effectedObject : Node3D

@export var probeContainer : Node3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale

var probeList := []

func _ready():
	
	probeList = probeContainer.get_children()
	
	if(effectedObject == null):
		
		effectedObject = self
		
func _physics_process(delta: float) -> void:
	apply_force(Vector3.DOWN * gravity, global_position)
	var wave = waterPlane.get_wave(global_position.x, global_position.z)
	var wave_height = -wave.y
	var height = global_position.y 
	#print("Wave_height is " + str(wave_height) + " and height is " + str(height))
	if height < wave_height:
		
		global_position.y = wave_height
		
