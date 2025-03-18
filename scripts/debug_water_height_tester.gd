extends Node3D

@export var objectToCheckHeightAt : Node3D

@export var waterPlane : MeshInstance3D

var frameCounter = 0

func _physics_process(delta: float) -> void:
	frameCounter += 1
	if(frameCounter % 30 == 0):
		print("Height at player position" + str(waterPlane.get_wave(objectToCheckHeightAt.global_position.x, objectToCheckHeightAt.global_position.z)))
		print("PlayerPosition is " + str(objectToCheckHeightAt.global_position))
		objectToCheckHeightAt.global_position.y = waterPlane.get_wave(objectToCheckHeightAt.global_position.x, objectToCheckHeightAt.global_position.z).y
