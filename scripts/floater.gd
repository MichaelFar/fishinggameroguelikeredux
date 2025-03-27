extends RigidBody3D

@export var waterPlane : MeshInstance3D

@export var float_coefficient := 1.0
@export var water_drag := 0.99
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale

@export var probeContainer : Node3D

@export var physicsControlled : bool

@export var useTorque : bool = true

var hasHitWater : bool = false

var probeList := []

var submerged := false

var depthBeforeSubmerged := 1.0

var displacementAmount := 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	probeList = probeContainer.get_children()
	#axis_lock_angular_z = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	submerged = false
	
	for i in probeList:
		var world_coord_offset = i.global_position - global_position
		
		var wave = waterPlane.get_wave(i.global_position.x, i.global_position.z)
		var wave_height = wave.y 
		var height = i.global_position.y
		if(physicsControlled): apply_force(Vector3.DOWN * gravity, world_coord_offset)
		#print("Wave_height is " + str(wave_height) + " and height is " + str(height))
		if height < wave_height:
			#var displacementMult = clampf((-i.global_position.y / depthBeforeSubmerged) * displacementAmount, 0, 1)
			if(physicsControlled):
				
				var buoyancy = clampf((wave_height - height), 0, 2) * 2
				var absolute_value_position = Vector3(i.global_position.x, absf(i.global_position.y), i.global_position.z)
				apply_force(Vector3(0, gravity * buoyancy * float_coefficient, 0), absolute_value_position)
				apply_central_force(buoyancy * water_drag * (-linear_velocity)  * float_coefficient)
				apply_torque(buoyancy * -angular_velocity * water_angular_drag)
			else:
				global_position.y = wave_height
		
			
		
	


	
