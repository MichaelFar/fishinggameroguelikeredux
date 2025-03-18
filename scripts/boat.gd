extends RigidBody3D

@export var waterPlane : MeshInstance3D

@export var float_force := 1.0
@export var water_drag := 0.99
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale

@export var probeContainer : Node3D



var probeList := []

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	probeList = probeContainer.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	submerged = false
	

		#else:
			#apply_force(Vector3.DOWN * float_force *  -1 * gravity * depth, p.global_position - global_position)
		#align_with_y(global_transform,)
		
		
		
		# It had to be a world coord offset.... not just relative to the parent...
		# reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
	
	
	for i in probeList:
		var world_coord_offset = i.global_position - global_position
		apply_force(Vector3.DOWN * gravity, world_coord_offset)
		var wave = waterPlane.get_wave(i.global_position.x, i.global_position.z)
		var wave_height = wave.y
		var height = i.global_position.y
		print("Wave_height is " + str(wave_height) + " and height is " + str(height))
		if height < wave_height:
			
			var buoyancy = clamp((wave_height - height), 0, 2) * 2
			apply_force(Vector3(0, gravity * buoyancy, 0), world_coord_offset)
			apply_central_force(buoyancy * water_drag * (-linear_velocity))
			apply_torque(buoyancy * -angular_velocity * water_angular_drag)
		
		#i.position.y = wave_height
	


	
