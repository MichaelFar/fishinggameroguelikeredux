extends Node3D

@export var restingRod : MeshInstance3D

@export var rodTiltBack : MeshInstance3D

@export var rodTiltRight : MeshInstance3D

@export var rodTiltLeft : MeshInstance3D

@export var bobber_scene : PackedScene

@export var timeToCast := 0.4

var globalDelta := 0.0

var castAlpha := 0.0

var restingAngle := 0.0

enum RODSTATES {RESTING, DRAWING, RELEASED}

var rodState : RODSTATES = RODSTATES.RESTING

signal released_bobber

func _ready():
	
	restingAngle = restingRod.rotation_degrees.z

func _physics_process(delta: float) -> void:
	
	globalDelta = delta

func _input(event: InputEvent) -> void:
	if(rodState == RODSTATES.RESTING):
		if(event.is_action("Cast") && event.is_pressed()):
			rodState = RODSTATES.DRAWING
			var tween = get_tree().create_tween()
			tween.tween_property(restingRod, "rotation_degrees:z", 65.0, timeToCast)
			
	if(rodState == RODSTATES.DRAWING):
		if(event.is_action_released("Cast")):
			rodState = RODSTATES.RESTING
			var tween = get_tree().create_tween()
			tween.tween_property(restingRod, "rotation_degrees:z", restingAngle, timeToCast)
		elif(event.is_action_released("release")):
			rodState = RODSTATES.RELEASED
			var tween = get_tree().create_tween()
			tween.tween_property(restingRod, "rotation_degrees:z", restingAngle, timeToCast / 3)
	if(rodState == RODSTATES.RELEASED):
		if(event.is_action_released("Cast")):
			rodState = RODSTATES.RESTING
			var tween = get_tree().create_tween()
			tween.tween_property(restingRod, "rotation_degrees:z", restingAngle, timeToCast)

func launch_bobber():
	
	var bobber_object = bobber_scene.instantiate()
	
	
	
