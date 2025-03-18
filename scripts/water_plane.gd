@tool
extends MeshInstance3D

var material : ShaderMaterial

@export var noise : NoiseTexture2D

var noiseScale : float

var waveSpeed : float

var heightScale : float

var time : float = 0

var waveScale : float

var noiseValue : float

var noiseImage : Image

@export var WaveA : Vector4

@export var WaveB : Vector4

@export var WaveC : Vector4

@export var WaveD : Vector4

@export var WaveE : Vector4
func _ready():
	material = mesh.surface_get_material(0)
	material.set_shader_parameter("WaveA", WaveA)
	material.set_shader_parameter("WaveB", WaveB)
	material.set_shader_parameter("WaveC", WaveC)
	material.set_shader_parameter("WaveD", WaveD)
	material.set_shader_parameter("WaveE", WaveE)
	#noise = material.get_shader_parameter("noise_texture")
	
#	noiseImage = noise.noise.get_image(noise.get_height(),noise.get_width())
	print("noise image is "+str(noiseImage))
	#waveSpeed = material.get_shader_parameter()
	#heightScale = 2 * material.get_shader_parameter("wave_strength")
	#waveScale = material.get_shader_parameter("wave_scale")
	#noiseValue = material.get_shader_parameter("noise_value")
	#material.set_shader_parameter("noise_texture", noise)
func _process(delta):
	time += delta
	material.set_shader_parameter("wave_time", time)
	#print("world position of vertex in shader is " + str(Vector3(material.get("world_position"))))
	#noiseValue = material.get_shader_parameter("noise_value")

func get_height(world_position : Vector3) ->float:
	pass
	#var noise_value = texture(noise, world_position.xy * waveScale).r;
	#noiseValue = wrapf(noiseValue,0,1)
	#var uv_x = wrapf(sin(world_position.x * 0.2 + time + noiseValue * 10.0) * heightScale,0,1);
	#var uv_y = wrapf(sin(world_position.z * 0.2 + time + noiseValue * 10.0) * heightScale,0,1);
	#
	#var pixel_pos = Vector2(uv_x * noise.get_width(), uv_y * noise.get_height())
	#return noiseImage.get_pixelv(pixel_pos).r * heightScale
	return 0
func get_normal():
	pass
	
func dot(a : Vector2, b : Vector2):
	
	return (a.x * b.x) + (a.y * b.y)
	
func P(wave: Vector4, p: Vector2, t = 0):
	t = time
	
	var wave_dir = Vector2(wave.x,wave.z)
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
