extends RigidBody3D

@export var waterPlane : MeshInstance3D

@export var float_force := 1.0
@export var water_drag := 0.05
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
	for p in probeList:
		var depth = waterPlane.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
		#else:
			#apply_force(Vector3.DOWN * float_force *  -1 * gravity * depth, p.global_position - global_position)
	#align_with_y(global_transform,)
func _integrate_forces(state: PhysicsDirectBodyState3D):
	
	if submerged:
		
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
		
func align_with_y(xform, new_y):
	
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
