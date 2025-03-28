extends Node3D

@export var restingRod : MeshInstance3D

@export var rodTiltBack : MeshInstance3D

@export var rodTiltRight : MeshInstance3D

@export var rodTiltLeft : MeshInstance3D

@export var bobber_scene : PackedScene

@export var spawnPoint : Marker3D

@export var dynamicLineMeshScene : PackedScene

var currentLineInstance = null

@export var rodTipMarker : Marker3D

@export var timeToCast := 0.4

@export var timeToDraw := 0.4

@export var forceMagnitude := 20.0

@export var finalDrawBackZ := -0.089

var globalDelta := 0.0

var castAlpha := 0.0

var restingAngle := 0.0

var initialZPosition := 0.0

enum RODSTATES {RESTING, DRAWING, RELEASED}

var rodState : RODSTATES = RODSTATES.RESTING

var currentBobber : RigidBody3D

signal released_bobber

func _ready():
	
	initialZPosition = restingRod.position.z
	restingAngle = restingRod.rotation_degrees.z
	
func _physics_process(delta: float) -> void:
	
	globalDelta = delta
		
func _input(event: InputEvent) -> void:
	
	if(rodState == RODSTATES.RESTING):
		
		if(event.is_action_pressed("draw")):
			
			transition_to_state(RODSTATES.DRAWING)
	
	if(rodState == RODSTATES.DRAWING):
		
		if(event.is_action_released("draw")):
			
			transition_to_state(RODSTATES.RESTING)
		
		elif(event.is_action_released("release")):
			
			transition_to_state(RODSTATES.RELEASED)
			
	if(rodState == RODSTATES.RELEASED):
		
		if(event.is_action_released("draw")):
			
			transition_to_state(RODSTATES.RESTING)
			
func launch_bobber():
	
	var bobber_object : RigidBody3D = bobber_scene.instantiate()
	
	Global.currentLevel.add_child(bobber_object)
	
	bobber_object.waterPlane = Global.currentLevel.waterPlane
	
	bobber_object.global_position = spawnPoint.global_position
	#bobber_object.global_basis = bobber_object.global_basis.looking_at(restingRod.global_basis.x)
	bobber_object.apply_central_impulse( restingRod.global_basis.x * forceMagnitude)
	print("Force applied is " + str(restingRod.global_basis.x * forceMagnitude))
		
	currentBobber = bobber_object
	
	spawn_line(currentBobber)
	
func draw_line():
	
	pass

func spawn_line(object_to_follow):
	
	var line_instance := dynamicLineMeshScene.instantiate()
	line_instance.objectToFollow = object_to_follow
	line_instance.spawnObject = rodTipMarker
	add_child(line_instance)
	currentLineInstance = line_instance

func transition_to_state(new_state : RODSTATES):
	match new_state:
		
		RODSTATES.DRAWING:
			
			if(currentBobber != null):
				
				if(currentLineInstance != null):
					
					currentLineInstance.queue_free()
				
				currentBobber.queue_free()
				
			print("Entering drawing state from resting")
			rodState = RODSTATES.DRAWING
			var tween = get_tree().create_tween()
			
			tween.set_trans(Tween.TRANS_BACK)
			tween.tween_property(restingRod, "rotation_degrees:z", 65.0, timeToCast)
			tween.set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(restingRod, "position:z", finalDrawBackZ, timeToCast)
		
		RODSTATES.RESTING:
			
			rodState = RODSTATES.RESTING
			print("Entering resting state from drawing")
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.tween_property(restingRod, "rotation_degrees:z", restingAngle, timeToCast)
			tween.parallel().tween_property(restingRod, "position:z", initialZPosition, timeToCast)
		
		RODSTATES.RELEASED:
			
			rodState = RODSTATES.RELEASED
			print("Entering released state from drawing")
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.tween_property(restingRod, "rotation_degrees:z", restingAngle, timeToCast / 1.2)
			tween.parallel().tween_property(restingRod, "position:z", initialZPosition, timeToCast / 1.2)
			tween.finished.connect(launch_bobber)
