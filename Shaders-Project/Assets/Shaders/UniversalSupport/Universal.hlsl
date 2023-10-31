//Supports Universal 6.0.2
REQUIRED_FLEXUS_CORE_HLSL_VERSION_131
#define REQUIRED_UNIVERSAL_HLSL_VERSION_602

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#if defined (SHADOWS_SCREEN) && defined(UNITY_NO_SCREENSPACE_SHADOWS) && defined(SHADOWS_NATIVE)
#define UNIVERSAL_SHADOW_ATTENUATION(a) (_ShadowMapTexture.SampleCmpLevelZero(sampler_ShadowMapTexture,a._ShadowCoord.xy,a._ShadowCoord.z))
#else
#define UNIVERSAL_SHADOW_ATTENUATION(a) SHADOW_ATTENUATION(a)
#endif

//??
#if !VERTEXLIGHT_ON && POINT_LIGHTS_ON
	#define POINT_LIGHTS_ON 0
#endif

// #if POINT_LIGHTS_ON && !defined(UNIVERSAL_HD)
// 	#define UNIVERSAL_HD 1
// #endif

#if defined(USE_TEXTURE) || defined(ALBEDO_ALPHA_IS_AO) || defined(USE_NORMAL_MAP) || defined(NOR_BLUE_IS_NONMETALLIC) || defined(NOR_ALPHA_IS_ROUGHNESS) || defined(TEST_TEXTURES) || USE_EMISSION_TEX
	#define UV_NEEDED 1
#endif

#if defined(USE_GRADIENT_WORLD_X) || defined(USE_GRADIENT_WORLD_Y) || defined(USE_GRADIENT_WORLD_Z) || defined(USE_GRADIENT_OBJECT_X) || defined(USE_GRADIENT_OBJECT_Y) || defined(USE_GRADIENT_OBJECT_Z)
	#define WS_POS_NEEDED 1
#endif

struct universal_vertex_input {
	float4 vertex : POSITION;
	half3 normal : NORMAL;
	#ifdef UV_NEEDED
		float2 uv : TEXCOORD0;
	#endif
	#if defined(USE_NORMAL_MAP) && defined(UV_MODE_MODEL_UV)
		half4 tangent : TANGENT;
	#endif
	#ifdef LIGHTMAP_ON
		float2 uv_gi : TEXCOORD1;
	#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct universal_v2f {
	float4 pos : SV_POSITION;
	#ifdef UV_NEEDED
		half2 uv : TEXCOORD0;
	#endif
	#ifdef LIGHTMAP_ON
		float2 uv_gi : TEXCOORD6;
	#endif
	//float depth : TEXCOORD3;
	#ifdef UNIVERSAL_HD
	float3 N : NORMAL;
	#else
	half3 N : NORMAL;
	#endif
	#if defined(UNIVERSAL_HD) || defined(WS_POS_NEEDED)
	float3 ws_pos : TEXCOORD3;
	#else
	half3 V : TEXCOORD3;
	#endif
	#if defined(USE_NORMAL_MAP) && defined(UV_MODE_MODEL_UV)
	half3 tangent : TEXCOORD4;
	half3 bitangent : TEXCOORD5;
	#endif
	SHADOW_COORDS(1)
	UNITY_FOG_COORDS(2)
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

#if defined(USE_NORMAL_MAP) && UV_MODE_MODEL_UV
inline half3 UniversalApplyNormalMap(universal_v2f i, half3 normal_map) {
	half3 N;
	N.x = i.tangent.x * normal_map.x + i.bitangent.x * normal_map.y + i.N.x * normal_map.z;
	N.y = i.tangent.y * normal_map.x + i.bitangent.y * normal_map.y + i.N.y * normal_map.z;
	N.z = i.tangent.z * normal_map.x + i.bitangent.z * normal_map.y + i.N.z * normal_map.z;
	return N;
}
#else
inline half3 UniversalApplyNormalMap(universal_v2f i, half3 normal_map) {
	return i.N;
}
#endif

struct universal_data {
	half3 N; // Normal
	half3 V; // View vector
	float3 L; // Light
	half3 R; // Reflection vector
	float3 H; // Half vector (V + L)
	half NdotV;
	half NdotL;
	float NdotH;
	half fresnel;
	half shadow;
	half lambert;
	half lambert_raw;
	half3 light;
	half3 lightmap;
	half specular;
	half4 tint;
	half4 tex;
	half3 albedo;
	half occlusion;
	half4 normal_texture;
	half3 normal_map;
	half nonmetallic;
	half roughness;
	half3 emission;
	half3 sky_data;
};

#if UV_MODE_MODEL_UV
	#define CALCULATE_UV uv = v.uv;
#endif
#if UV_MODE_OBJECT_SPACE
	#define CALCULATE_UV uv = os_uv;
#endif
#if UV_MODE_WALL
	#define CALCULATE_UV \
	half wall_width = OBJECT_SCALE_X / OBJECT_SCALE_Y;\
	uv.x = v.uv.x * wall_width;\
	uv.y = v.uv.y;
#endif
#if UV_MODE_FLOOR
	#define CALCULATE_UV \
	uv = float2(os_uv.x + (floor(OBJECT_ORIGIN.x * GET(_MainTex_ST).x * 2) % 2) / GET(_MainTex_ST).x * .5, os_uv.y);
#endif

#define APPLY_UV_MODE(n) \
float3 os_pos = ws_pos - OBJECT_ORIGIN;\
float2 os_uv = GetWorldSpaceUV(n, os_pos);\
CALCULATE_UV



#if USE_NORMAL_MAP && UV_MODE_MODEL_UV
#define UNIVERSAL_TRANSFER_TANGENT(vo) \
vo.tangent = UnityObjectToWorldDir(v.tangent.xyz);\
half tangent_sign = v.tangent.w * unity_WorldTransformParams.w;\
vo.bitangent = cross(o.N, vo.tangent) * tangent_sign;
#else
#define UNIVERSAL_TRANSFER_TANGENT(vo)
#endif

#if USE_CUBEMAP_LOCAL
	#define __CUBEMAP_NAME _Cubemap
	samplerCUBE _Cubemap;
#else
	#define __CUBEMAP_NAME unity_SpecCube0
#endif

#ifndef UNITY_STANDARD_INPUT_INCLUDED
sampler2D _MainTex;
#endif
sampler2D _NormalMap;
sampler2D _EmissionTex;
// Test
sampler2D _RoughnessTex;
sampler2D _MetallicTex;
sampler2D _OcclusionTex;

// float4 _MainTex_ST;
// half4 _Color;
// half4 _Color2;
// float2 _GradientSettings;
// half4 _GlowColor;
// half _SpecularMultiplier;
// half _Roughness;
// half _GlowPower;
// half3 _CubemapColor;
// half _CubemapPower;
// float4 _Cubemap_HDR;
// half _Saturation;
// half _Brightness;
#ifndef MOD_INSTANCED_PROPS
#define MOD_INSTANCED_PROPS
#endif

#define UNIVERSAL_DEFINE_INSTANCING_BUFFER
// #define UNIVERSAL_DEFINE_INSTANCING_BUFFER \
// UNITY_INSTANCING_BUFFER_START(PROPS)\
// UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)\
// UNITY_DEFINE_INSTANCED_PROP(float4, _Cubemap_HDR)\
// UNITY_DEFINE_INSTANCED_PROP(half4, _Color)\
// UNITY_DEFINE_INSTANCED_PROP(half4, _Color2)\
// UNITY_DEFINE_INSTANCED_PROP(half4, _GlowColor)\
// UNITY_DEFINE_INSTANCED_PROP(half3, _CubemapColor)\
// UNITY_DEFINE_INSTANCED_PROP(half, _SpecularMultiplier)\
// UNITY_DEFINE_INSTANCED_PROP(half, _Roughness)\
// UNITY_DEFINE_INSTANCED_PROP(half, _GlowPower)\
// UNITY_DEFINE_INSTANCED_PROP(half, _CubemapPower)\
// UNITY_DEFINE_INSTANCED_PROP(half, _Saturation)\
// UNITY_DEFINE_INSTANCED_PROP(half, _Brightness)\
// UNITY_DEFINE_INSTANCED_PROP(float2, _GradientSettings)\
// MOD_INSTANCED_PROPS \
// UNITY_INSTANCING_BUFFER_END(PROPS)

float4 _Cubemap_HDR;
half4 _Color2;
half _SpecularMultiplier;
half _Roughness;
half _CubemapPower;
half _Saturation;
half _Brightness;
float2 _GradientSettings;
half4 _GlowColor;
half3 _CubemapColor;
half _GlowPower;

///UNITY_DEFINE_INSTANCED_PROP(float4, __CUBEMAP_NAME##_HDR)\

//#define GET(p) p

#define UNIVERSAL_CALCULATE_SHADOW data.shadow = UNIVERSAL_SHADOW_ATTENUATION(i);
#define UNIVERSAL_CALCULATE_NDOTV(data) data.NdotV = dot(data.N, data.V);
#define UNIVERSAL_CALCULATE_NDOTL(data) data.NdotL = dot(data.N, data.L);
#define UNIVERSAL_CALCULATE_FRESNEL(data) data.fresnel = max(1 - saturate(data.NdotV), 1e-6);
#define UNIVERSAL_CALCULATE_R(data) data.R = reflect_NdotV(data.V, data.N, data.NdotV);
#define UNIVERSAL_CALCULATE_H(data) data.H = normalize(data.L + data.V);
#define UNIVERSAL_CALCULATE_NDOTH(data) data.NdotH = dot(data.N, data.H);

#if TEST_TEXTURES || ALBEDO_ALPHA_IS_AO
	#define __occlusion_mult * data.occlusion
#else
	#define __occlusion_mult
#endif

#if LIGHT_MODE_SOFT_LAMBERT
	#define UNIVERSAL_CALCULATE_LAMBERT_RAW data.lambert_raw = (min(data.NdotL * .5, data.shadow * .5) + .5);
	#define __specular_mult data.shadow * saturate(data.NdotL)
	#define __lambert data.lambert_raw
#else
	#define UNIVERSAL_CALCULATE_LAMBERT_RAW data.lambert_raw = saturate(data.NdotL) * data.shadow;
	#define __specular_mult data.lambert_raw
	#define __lambert (SHADOW_STRENGTH + data.lambert_raw * (1 - SHADOW_STRENGTH))
#endif

#define UNIVERSAL_CALCULATE_LAMBERT \
UNIVERSAL_CALCULATE_LAMBERT_RAW \
data.lambert = __lambert;

#define UNIVERSAL_CALCULATE_LIGHT data.light = (data.lambert * _LightColor0.rgb + unity_AmbientSky) __occlusion_mult;

#if USE_CUBEMAP_LOCAL
	#define UNIVERSAL_GET_SKY_DATA data.sky_data = UniversalGetSkyData(_Cubemap, GET(_Cubemap_HDR), data.R, data.roughness);
#else
	#define UNIVERSAL_GET_SKY_DATA data.sky_data = DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, data.R, MipMapFromRoughness(data.roughness)), unity_SpecCube0_HDR);
#endif

#define UNIVERSAL_CALCULATE_NORMAL_DATA(data) \
UNIVERSAL_CALCULATE_NDOTV(data) \
UNIVERSAL_CALCULATE_NDOTL(data) \
UNIVERSAL_CALCULATE_FRESNEL(data) \
UNIVERSAL_CALCULATE_R(data) \
UNIVERSAL_CALCULATE_H(data) \
UNIVERSAL_CALCULATE_NDOTH(data) \

inline half3 UniversalColorCorrection(half3 color, half lambert, half saturation, half brightness) {
	half3 dark = color * brightness;
	// half minc = min(dark.r, min(dark.g, dark.b));
	// half maxc = max(dark.r, max(dark.g, dark.b));
	// half avgc = (maxc + minc) * .5;
	half avgc = (dark.r + dark.g + dark.b) * .333;

	half3 saturated = saturate(dark + dark - avgc);
	return lerp(color, lerp(saturated, color * 1.5, lambert), saturation);
}

inline half MipMapFromRoughness(half roughness) {
	//return pow(roughness, .25) * 10;
	//return roughness * 10;
	//return sqrt(roughness) * 9;
	return EaseOutQuad(roughness) * 9;
	//return pow(roughness*(1.7 - 0.7*roughness),.5)*8;
}

inline half3 UniversalGetSkyData(samplerCUBE cubemap, float4 cubemap_hdr, half3 R, half roughness) {
	half4 skyData = texCUBElod(cubemap, float4(R, MipMapFromRoughness(roughness)));
	return DecodeHDR(skyData, cubemap_hdr);
}

inline half4 UniversalCubemap(half4 color, half3 skyData, half power, half3 skyColor, half fresnel, half3 texColor) {
	half fresnelPowCP = pow(fresnel, power);// * NOT_REFLECTION_PROBE_RENDER;
	half alpha = color.a + max(skyData.r, max(skyData.g, skyData.b)) * fresnelPowCP;
	return half4(color.rgb * (1 - fresnelPowCP) + skyData * skyColor * texColor * fresnelPowCP, alpha);
}

inline half4 UniversalGlow(half fresnel, half power, half4 color) {
	//return (pow(fresnel, power) > .5) * color; // toon gloss
	return pow(fresnel, power) * color;
}

inline half UniversalSpecular(float d, half roughness) {
	half r2 = max(roughness * roughness, .0001);
	half specular = (saturate(r2 + d * d - 1) / r2 - .32) * (1 - r2) + .32;
	return specular * specular * (1 - r2) * 2;
}

// inline half3 CalculatePointLights(float3 ws_pos, half3 N) {
//
// 	float4 toLightX = unity_4LightPosX0 - ws_pos.x;
//     float4 toLightY = unity_4LightPosY0 - ws_pos.y;
//     float4 toLightZ = unity_4LightPosZ0 - ws_pos.z;
// 	float4 lengthSq = 0;
//     lengthSq += toLightX * toLightX;
//     lengthSq += toLightY * toLightY;
//     lengthSq += toLightZ * toLightZ;
// 	// NdotL
//     float4 ndotl = 0;
//     ndotl += toLightX * N.x;
//     ndotl += toLightY * N.y;
//     ndotl += toLightZ * N.z;
//     // correct NdotL
//     float4 corr = rsqrt(lengthSq);
//     ndotl = max (float4(0,0,0,0), ndotl * corr);
//
// 	float4 ranges = (0.005 * sqrt(1000000.0 - unity_4LightAtten0)) / sqrt(unity_4LightAtten0);
//     float4 atten01 = lengthSq * corr / ranges;
//     float4 atten = saturate(1.0 / (1.0 + 25.0 * atten01 * atten01) * saturate((1.0 - atten01) * 5.0));
//     float4 diff = ndotl * atten;
//
// 	half3 light = 0;
// 	light += unity_LightColor[0].rgb * diff.x;
//     light += unity_LightColor[1].rgb * diff.y;
//     light += unity_LightColor[2].rgb * diff.z;
//     light += unity_LightColor[3].rgb * diff.w;
//
// 	return light;
// }

#if defined(ALBEDO_ALPHA_IS_AO) || !defined(USE_TEXTURE)
	#define __alpha data.tint.a
#else
	#define __alpha data.tex.a * data.tint.a
#endif

#ifdef USE_TEXTURE
#define UNIVERSAL_SET_ALBEDO \
data.tex = tex2D(_MainTex, i.uv); \
data.albedo = data.tex.rgb * data.tint.rgb; \
color.a = __alpha;
#else
#define UNIVERSAL_SET_ALBEDO \
data.tex = 1; \
data.albedo = data.tint.rgb; \
color.a = __alpha;
#endif

#ifdef USE_GLOW
	#define UNIVERSAL_ADD_GLOW color += UniversalGlow(data.fresnel, GET(_GlowPower), GET(_GlowColor));
#else
	#define UNIVERSAL_ADD_GLOW
#endif

#ifdef USE_SPECULAR
	#define UNIVERSAL_ADD_SPECULAR \
	data.specular = UniversalSpecular(data.NdotH, data.roughness) * __specular_mult * GET(_SpecularMultiplier);\
	color += half4(data.specular * _LightColor0.rgb, data.specular);
#else
	#define UNIVERSAL_ADD_SPECULAR
#endif

// #if LIGHTMAP_ON && (LIGHT_MODE_LAMBERT || LIGHT_MODE_BAKED_ONLY || LIGHT_MODE_SOFT_LAMBERT)
// 	#define __cubemap_specular_mult * data.light
// #else
// 	#define __cubemap_specular_mult
// #endif

#if USE_CUBEMAP_LOCAL || USE_CUBEMAP_GLOBAL
	#define UNIVERSAL_ADD_CUBEMAP \
	UNIVERSAL_GET_SKY_DATA \
	color = UniversalCubemap(color, data.sky_data * data.light, data.nonmetallic, GET(_CubemapColor), data.fresnel, data.tex.rgb);
#else
	#define UNIVERSAL_ADD_CUBEMAP
#endif

#ifdef USE_CC
#define UNIVERSAL_APPLY_CC color.rgb = UniversalColorCorrection(color.rgb, data.lambert, GET(_Saturation), GET(_Brightness));
#else
#define UNIVERSAL_APPLY_CC
#endif

#if POINT_LIGHTS_ON
	#define UNIVERSAL_ADD_POINT_LIGHTS data.light += CalculatePointLights(i.ws_pos, data.N);
#else
	#define UNIVERSAL_ADD_POINT_LIGHTS
#endif

#ifdef USE_ALPHA
#define UNIVERSAL_RETURN saturate(color)
#else
#define UNIVERSAL_RETURN half4(saturate(color.rgb), 1)
#endif

#if USE_GRADIENT_DISABLED
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = GET(_Color);\
UNIVERSAL_MOD_GRADIENT_INJECTION
#endif
#if USE_GRADIENT_FRESNEL
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), sqrt(data.fresnel));
#endif
#if USE_GRADIENT_WORLD_X
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((i.ws_pos.x - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif
#if USE_GRADIENT_WORLD_Y
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((i.ws_pos.y - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif
#if USE_GRADIENT_WORLD_Z
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((i.ws_pos.z - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif
#if USE_GRADIENT_OBJECT_X
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((mul(unity_WorldToObject, float4(i.ws_pos, 1)).x - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif
#if USE_GRADIENT_OBJECT_Y
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((mul(unity_WorldToObject, float4(i.ws_pos, 1)).y - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif
#if USE_GRADIENT_OBJECT_Z
#define UNIVERSAL_APPLY_GRADIENT_TINT data.tint = lerp(GET(_Color), GET(_Color2), saturate((mul(unity_WorldToObject, float4(i.ws_pos, 1)).z - GET(_GradientSettings).x) / (GET(_GradientSettings).y - GET(_GradientSettings).x))); // _GradientSettings.z can store 1 / (_GradientSettings.y - _GradientSettings.x)
#endif



#ifndef UNIVERSAL_MOD_OS_POS_INJECTION
#define UNIVERSAL_MOD_OS_POS_INJECTION
#endif
#ifndef UNIVERSAL_MOD_WS_POS_INJECTION
#define UNIVERSAL_MOD_WS_POS_INJECTION
#endif
#ifndef UNIVERSAL_MOD_VERTEX_OS_NORMAL_INJECTION
#define UNIVERSAL_MOD_VERTEX_OS_NORMAL_INJECTION
#endif
#ifndef UNIVERSAL_MOD_VERTEX_WS_NORMAL_INJECTION
#define UNIVERSAL_MOD_VERTEX_WS_NORMAL_INJECTION
#endif
#ifndef UNIVERSAL_MOD_GRADIENT_INJECTION
#define UNIVERSAL_MOD_GRADIENT_INJECTION
#endif
#ifndef UNIVERSAL_MOD_ALBEDO_INJECTION
#define UNIVERSAL_MOD_ALBEDO_INJECTION
#endif
#ifndef UNIVERSAL_MOD_LIGHT_INJECTION
#define UNIVERSAL_MOD_LIGHT_INJECTION
#endif
#ifndef UNIVERSAL_MOD_FINAL_INJECTION
#define UNIVERSAL_MOD_FINAL_INJECTION
#endif

#include "UniversalDebug.hlsl"

// FOR FUTURE SHADOW IMPROVEMENTS
// #define TRANSFER_SHADOW(a) a._ShadowCoord = mul( unity_WorldToShadow[0], mul( unity_ObjectToWorld, v.vertex ) );
// #define SHADOW_COORDS(idx1) unityShadowCoord4 _ShadowCoord : TEXCOORD##idx1;
//
// #undef UNITY_DECLARE_SHADOWMAP
// #define UNITY_DECLARE_SHADOWMAP(tex) sampler2D tex; SamplerComparisonState sampler##tex
// UNITY_DECLARE_SHADOWMAP(_ShadowMapTexture);
//
//
// // SHADOW (COPY FROM AutoLight.cginc)
// #if defined (SHADOWS_SCREEN)
//
//     #if defined(UNITY_NO_SCREENSPACE_SHADOWS)
//         inline half UniversalSampleShadow (unityShadowCoord4 shadowCoord)
//         {
//             #if defined(SHADOWS_NATIVE) // OUR CASE
//                 //half shadow = _ShadowMapTexture.SampleCmpLevelZero(sampler_ShadowMapTexture,shadowCoord.xy,shadowCoord.z);//UNITY_SAMPLE_SHADOW(_ShadowMapTexture, shadowCoord.xyz);
// 				half dist = SAMPLE_DEPTH_TEXTURE(_ShadowMapTexture, shadowCoord.xy) - shadowCoord.z;
// 				//dist = 1 - dist;
// 				dist = dist < 1e-6 ? 1 : dist;
// 				float mind = 0;
// 				float maxd = 1;
// 				dist *= 1. / _LightShadowData.z;
// 				float near = _LightShadowData.w;
// 				half shadow = min(dist, maxd) / maxd;// * (far-near) + near;
// 				return shadow;
//             #else
//                 unityShadowCoord dist = SAMPLE_DEPTH_TEXTURE(_ShadowMapTexture, shadowCoord.xy);
//                 // tegra is confused if we use _LightShadowData.x directly
//                 // with "ambiguous overloaded function reference max(mediump float, float)"
//                 unityShadowCoord lightShadowDataX = _LightShadowData.x;
//                 unityShadowCoord threshold = shadowCoord.z;
//                 return max(dist > threshold, lightShadowDataX);
//             #endif
//         }
//
//     #else // UNITY_NO_SCREENSPACE_SHADOWS
//         UNITY_DECLARE_SCREENSPACE_SHADOWMAP(_ShadowMapTexture);
//         inline half UniversalSampleShadow (unityShadowCoord4 shadowCoord)
//         {
//             half shadow = UNITY_SAMPLE_SCREEN_SHADOW(_ShadowMapTexture, shadowCoord);
//             return shadow;
//         }
//
//     #endif
//
//     #define UNIVERSAL_SHADOW_ATTENUATION(a) UniversalSampleShadow(a._ShadowCoord)
// #endif

///////////
