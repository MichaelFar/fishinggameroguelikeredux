@tool
extends MeshInstance3D


@export_tool_button("Set Wave Shader Values", "Callable") var set_wave_action = setWaveShaderValues

var material : ShaderMaterial

var noiseScale : float

var waveSpeed : float

var heightScale : float

var time : float = 0

var waveScale : float

var noiseValue : float

@export var WaveA : Vector4

@export var WaveB : Vector4

@export var WaveC : Vector4

@export var WaveD : Vector4

@export var WaveE : Vector4
func _ready():
	material = mesh.surface_get_material(0)
	setWaveShaderValues()
	
	
func _process(delta):
	time += delta
	material.set_shader_parameter("wave_time", time)
	#print("world position of vertex in shader is " + str(Vector3(material.get("world_position"))))
	#noiseValue = material.get_shader_parameter("noise_value")
	#if(Input.is_action_just_released("ui_accept")):
		#print_face_list()
		
	
func dot(a : Vector2, b : Vector2):
	
	return (a.x * b.x) + (a.y * b.y)
	
func P(wave: Vector4, p: Vector2, t = 0):
	t = time
	
	var wave_dir = Vector2(wave.x,wave.y)
	var amplitude = wave.x
	var steepness = wave.z
	var wavelength = wave.w
	var k = 2.0 * PI / wavelength
	var c = sqrt(9.8 / k)
	var d = wave_dir.normalized()
	var f = k * (dot(d, p) - (c * t))
	var a = steepness / k
	
	var dx = d.x * a * cos(f)
	var dy = a * sin(f)
	var dz = d.y * a * cos(f)
	
	return Vector3(dx, dy, dz)
func _get_wave(x, z):
	var v = Vector3(x, 0, z)
	v += P(WaveA,Vector2(x, z), time)
	v += P(WaveB,Vector2(x, z), time)
	v += P(WaveC,Vector2(x, z), time)
	v += P(WaveD,Vector2(x, z), time)
	v += P(WaveE,Vector2(x, z), time)
	return v

func get_wave(x, z):
	var v0 = _get_wave(x, z)
	var offset = Vector2(x - v0.x, z - v0.z)
	var v1 = _get_wave(x+offset.x/4, z+offset.y/4)
	
	return v1
	
func setWaveShaderValues():
	material.set_shader_parameter("WaveA", WaveA)
	material.set_shader_parameter("WaveB", WaveB)
	material.set_shader_parameter("WaveC", WaveC)
	material.set_shader_parameter("WaveD", WaveD)
	material.set_shader_parameter("WaveE", WaveE)

func print_face_list():
	print("Number of faces is " + str(mesh.get_faces()))
