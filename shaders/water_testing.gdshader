shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform vec3 albedo : source_color;
uniform sampler2D water_texture1;
uniform sampler2D water_texture2;
uniform sampler2D noise_texture;
uniform vec2 scroll_speed1 = vec2(0.05, 0.0);
uniform vec2 scroll_speed2 = vec2(-0.03, 0.0);
uniform float blend_factor = 0.5;
uniform vec2 scale1 = vec2(1.0, 1.0);
uniform vec2 scale2 = vec2(1.0, 1.0);
uniform float wave_strength = 1.0;
uniform float wave_scale = 0.02;
uniform float wave_time = 0.0;
uniform int pixelation_level = 64;
uniform float FoamSize = 0.5;
uniform sampler2D DepthTexture : hint_depth_texture;

uniform float WaterOpacity = 1.0;
uniform float FoamGlowIntensity = 0.5;


//uniform float wavelength = 20;
uniform float amplitude = 2.0;
uniform float speed = 13;
//uniform float steepness = 0.3;
uniform vec2 direction = vec2(1);

uniform vec4 WaveA = vec4(1,0,0.5,30);
uniform vec4 WaveB = vec4(1,1,0.25,20);
uniform vec4 WaveC = vec4(1,1,0.25,20);

varying vec3 global_position;
varying float noise_value;
//varying vec3 normal;

vec3 GerstnerWave (vec4 wave, vec3 p, inout vec3 tangent, inout vec3 binormal)
{
			float steepness = wave.z;
		    float wavelength = wave.w;


		//TANGENT = normalize(
				//vec3(1.0 - steepness * sin(f),
				//steepness * cos(f),
				//0.0));

		    float k = 2.0 * PI / wavelength;
			float c = sqrt(9.8 / k);
			vec2 d = normalize(wave.xy);
			float f = k * (dot(d,p.xz) - c * TIME);
			float a = steepness / k;

			//VERTEX.y = amplitude * sin(k * VERTEX.x + TIME);
			p.x += a * cos(f);
			p.y = a * sin(f);

			//p.x += d.x * (a * cos(f));
			//p.y = a * sin(f);
			//p.z += d.y * (a * cos(f));

			tangent += vec3(
				-d.x * d.x * (steepness * sin(f)),
				d.x * (steepness * cos(f)),
				-d.x * d.y * (steepness * sin(f))
			);
			binormal += vec3(
				-d.x * d.y * (steepness * sin(f)),
				d.y * (steepness * cos(f)),
				-d.y * d.y * (steepness * sin(f))
			);
			return vec3(
				d.x * (a * cos(f)),
				a * sin(f),
				d.y * (a * cos(f))
			);
		}
void vertex() {


	vec3 gridPoint = VERTEX.xyz;
	vec3 tangent = vec3(1, 0, 0);
	vec3 binormal = vec3(0, 0, 1);
	vec3 p = gridPoint;
	p += GerstnerWave(WaveA, p, tangent, binormal);
	p += GerstnerWave(WaveB, p, tangent, binormal);
	p += GerstnerWave(WaveC, p, tangent, binormal);
	vec3 normal = normalize(cross(binormal, tangent));
	VERTEX.xyz = p;
	NORMAL = normal;

}


void fragment() {
    vec2 scaledUV1 = UV * scale1;
    vec2 scaledUV2 = UV * scale2;
    vec2 scrolledUV1 = scaledUV1 + scroll_speed1 * TIME;
    vec2 scrolledUV2 = scaledUV2 + scroll_speed2 * TIME;
    scrolledUV1 = mod(scrolledUV1, vec2(1.0, 1.0));
    scrolledUV2 = mod(scrolledUV2, vec2(1.0, 1.0));
    scrolledUV1 = floor(scrolledUV1 * float(pixelation_level)) / float(pixelation_level);
    scrolledUV2 = floor(scrolledUV2 * float(pixelation_level)) / float(pixelation_level);

    vec4 water_color1 = texture(water_texture1, scrolledUV1);
    vec4 water_color2 = texture(water_texture2, scrolledUV2);
    vec4 blended_water_color = mix(water_color1, water_color2, blend_factor);

    float depthValue = texture(DepthTexture, SCREEN_UV).r;
    vec4 worldPosition = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depthValue, 1.0);
    worldPosition.xyz /= worldPosition.w;
    float foamEffect = clamp(1.0 - smoothstep(worldPosition.z + FoamSize, worldPosition.z, VERTEX.z), 0.0, 1.0);
    float foamOpacity = 1.0 - foamEffect;
    float foamEffectRounded = round(foamOpacity);
    float finalOpacity = foamEffectRounded + WaterOpacity;

    ALBEDO = blended_water_color.rgb * albedo;
    ALPHA = finalOpacity;
    EMISSION = vec3(foamEffectRounded) * FoamGlowIntensity;
    METALLIC = 0.0;
    ROUGHNESS = 1.0;
}