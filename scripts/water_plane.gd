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

func _ready():
	material = mesh.surface_get_material(0)
	#noise = material.get_shader_parameter("noise_texture")
	
	noiseImage = noise.noise.get_image(noise.get_height(),noise.get_width())
	print("noise image is "+str(noiseImage))
	#waveSpeed = material.get_shader_parameter()
	heightScale = material.get_shader_parameter("wave_strength")
	waveScale = material.get_shader_parameter("wave_scale")
	#noiseValue = material.get_shader_parameter("noise_value")
func _process(delta):
	time += delta
	material.set_shader_parameter("wave_time", time)
	#noiseValue = material.get_shader_parameter("noise_value")

func get_height(world_position : Vector3) ->float:
	
	#var noise_value = texture(noise, world_position.xy * waveScale).r;
	var uv_x = wrapf(sin(world_position.x * 0.2 + time + noiseValue * 10.0) * heightScale,0,1);
	var uv_y = wrapf(sin(world_position.z * 0.2 + time + noiseValue * 10.0) * heightScale,0,1);
	
	var pixel_pos = Vector2(uv_x * noise.get_width(), uv_y * noise.get_height())
	return noiseImage.get_pixelv(pixel_pos).r * heightScale
func get_normal():
	pass
