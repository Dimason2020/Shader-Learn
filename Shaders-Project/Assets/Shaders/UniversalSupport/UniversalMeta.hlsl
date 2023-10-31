#include "UnityStandardMeta.cginc"
#include "UniversalSupport/Universal.hlsl"

REQUIRED_UNIVERSAL_HLSL_VERSION_602

#pragma vertex universal_vert_meta
#pragma fragment universal_frag_meta
#pragma shader_feature UV_MODE_MODEL_UV UV_MODE_OBJECT_SPACE UV_MODE_WALL UV_MODE_FLOOR
#pragma shader_feature USE_GLOW
#pragma shader_feature USE_EMISSION_TEX
#pragma shader_feature LIGHT_MODE_UNLIT
#pragma shader_feature USE_TEXTURE

// half3 _GlowColor;
// half _GlowPower;
// half3 _CubemapColor;
// half _EmissionMultiplier;

struct universal_meta_vertex_input
	{
		float4 vertex   : POSITION;
		half3 normal    : NORMAL;
		float2 uv      : TEXCOORD0;
		float2 uv1      : TEXCOORD1;
	#if defined(DYNAMICLIGHTMAP_ON) || defined(UNITY_PASS_META)
		float2 uv2      : TEXCOORD2;
	#endif
	};

v2f_meta universal_vert_meta (universal_meta_vertex_input v)
{
	v2f_meta o;
	o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
	//o.uv = TexCoords(v);
	half3 N = UnityObjectToWorldNormal(v.normal);
	CALCULATE_WORLD_POSITION(ws_pos)
	float2 uv = v.uv;

	APPLY_UV_MODE(N)

	o.uv.xy = TRANSFORM_TEX(uv, _MainTex);
	o.uv.zw = 0;

	#ifdef EDITOR_VISUALIZATION
	o.vizUV = 0;
	o.lightCoord = 0;
	if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
		o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.uv.xy, v.uv1.xy, v.uv2.xy, unity_EditorViz_Texture_ST);
	else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
	{
		o.vizUV = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
	}
	#endif
	return o;
}

float4 universal_frag_meta (v2f_meta i): SV_Target
{
	// we're interested in diffuse & specular colors,
	// and surface roughness to produce final albedo.
	FragmentCommonData data = UNITY_SETUP_BRDF_INPUT (i.uv);

	UnityMetaInput o;
	UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);

#ifdef EDITOR_VISUALIZATION
	o.Albedo = data.diffColor;
	o.VizUV = i.vizUV;
	o.LightCoord = i.lightCoord;
#else
	#ifdef USE_TEXTURE
	o.Albedo = tex2D(_MainTex, i.uv) * _Color.rgb;
	#else
	o.Albedo = _Color.rgb;
	#endif
#endif
	o.SpecularColor = _CubemapColor;
#ifdef USE_GLOW
	o.Emission = _GlowColor * pow(.5, _GlowPower);
#else
	o.Emission = 0;
#endif
#if USE_EMISSION_TEX
	o.Emission += tex2D(_EmissionTex, i.uv).rgb * _EmissionMultiplier;
#endif
#if LIGHT_MODE_UNLIT
	o.Emission += o.Albedo * _EmissionMultiplier;
	o.Albedo = 0;
#endif

	return UnityMetaFragment(o);
}
