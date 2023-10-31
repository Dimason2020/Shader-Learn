REQUIRED_UNIVERSAL_HLSL_VERSION_602

#ifdef DEBUG_MODE_FINAL_RENDER
#define UNIVERSAL_DEBUG_OVERLAY
#endif
#ifdef DEBUG_MODE_NORMAL
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.N * 0.5 + 0.5, 1);
#endif
#ifdef DEBUG_MODE_VERTEX_NORMALS
#define UNIVERSAL_DEBUG_OVERLAY color = half4(i.N * 0.5 + 0.5, 1);
#endif
#if DEBUG_MODE_NORMAL_MAP
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.normal_map * .5 + .5, 1);
#endif
#if DEBUG_MODE_UV
	#if UV_NEEDED
		#define UNIVERSAL_DEBUG_OVERLAY color = half4(i.uv * 8 % 1 / 2 + floor(i.uv % 1 * 8) / 16, 0, 1) + (abs(i.uv.x % 1 - .5) > .49 || abs(i.uv.y % 1 - .5) > .49) + half4(0,0,abs(i.uv.x * 8 % 1 - .5) > .48 || abs(i.uv.y * 8 % 1 - .5) > .48,0);
	#else
		#define UNIVERSAL_DEBUG_OVERLAY color = half4(1, 1, 0, 1);
	#endif
#endif
#ifdef DEBUG_MODE_NDOTV
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.NdotV + half3((data.NdotV < .000001) - (data.NdotV > .999999), 0, -(data.NdotV > .999999)), 1);
#endif
#ifdef DEBUG_MODE_NDOTL
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.NdotL.xxx, 1);
#endif
#if DEBUG_MODE_NDOTH
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.NdotH.xxx, 1);
#endif
#ifdef DEBUG_MODE_VIEW_VECTOR
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.V * 0.5 + 0.5, 1);
#endif
#ifdef DEBUG_MODE_REFLECTION_VECTOR
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.R * 0.5 + 0.5, 1);
#endif
#if DEBUG_MODE_HALF_VECTOR
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.H * 0.5 + 0.5, 1);
#endif
#ifdef DEBUG_MODE_FRESNEL
#define UNIVERSAL_DEBUG_OVERLAY color = half4(pow(data.fresnel, GET(_CubemapPower)).xxx, 1);
#endif
#ifdef DEBUG_MODE_SPECULAR
#define UNIVERSAL_DEBUG_OVERLAY color = half4((data.specular).xxx, 1);
#endif
#ifdef DEBUG_MODE_CUBEMAP
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.sky_data, 1);
#endif
#ifdef DEBUG_MODE_LAMBERT
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.lambert.xxx, 1);
#endif
#ifdef DEBUG_MODE_SHADOW
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.shadow.xxx, 1);
#endif
#ifdef DEBUG_MODE_LIGHT
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.light, 1);
#endif
#if DEBUG_MODE_POINT_LIGHTS
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(CalculatePointLights(i.ws_pos, data.N), 1);
#endif
#if DEBUG_MODE_LIGHTMAP
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.lightmap, 1);
#endif
#ifdef DEBUG_MODE_DIFFUSE
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.light * data.albedo, 1);
#endif
#ifdef DEBUG_MODE_ALBEDO
#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.albedo, 1);
#endif
#if DEBUG_MODE_ROUGHNESS
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.roughness.xxx, 1);
#endif
#if DEBUG_MODE_METALLIC
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(1 - data.nonmetallic.xxx * .5, 1);
#endif
#if DEBUG_MODE_OCCLUSION
	#define UNIVERSAL_DEBUG_OVERLAY color = half4(data.occlusion.xxx, 1);
#endif
#if DEBUG_MODE_CURVATURE
#define UNIVERSAL_DEBUG_OVERLAY float curvature = length(float2(ddx(data.fresnel), ddy(data.fresnel))) * 2;\
color = half4(curvature.xxx, 1);
#endif
#if DEBUG_MODE_DEPTH
#define UNIVERSAL_DEBUG_OVERLAY color = half4(i.depth.xxx / 100., 1);
#endif
#if DEBUG_MODE_WORLD_POSITION
#define UNIVERSAL_DEBUG_OVERLAY color = half4(i.ws_pos, 1);
#endif
#if DEBUG_MODE_MODEL_POSITION
#define UNIVERSAL_DEBUG_OVERLAY color = half4(mul(unity_WorldToObject, float4(i.ws_pos, 1)).xyz, 1);
#endif


#ifndef UNIVERSAL_DEBUG_OVERLAY
#define UNIVERSAL_DEBUG_OVERLAY
#endif
