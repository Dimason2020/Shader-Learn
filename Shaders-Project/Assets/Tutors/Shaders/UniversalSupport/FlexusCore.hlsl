// FLEXUS CORE v1.3.1
#define REQUIRED_FLEXUS_CORE_HLSL_VERSION_131
static const float PI = 3.14159265;
#define TIME _Time
#define DIR_LIGHT _WorldSpaceLightPos0.xyz
#define CAMERA_POS _WorldSpaceCameraPos

#ifdef SHADOWS_SCREEN
	#define SHADOW_STRENGTH _LightShadowData.x
#else
	// Unity don't transfer _LightShadowData when outside shadow distance
	// or if Shadows are off
	// Should be equal to (1 - Directional Light's Shadow Strength)
	#define SHADOW_STRENGTH 0
#endif

#define OBJECT_ORIGIN unity_ObjectToWorld._m03_m13_m23
#define OBJECT_SCALE_X length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x))
#define OBJECT_SCALE_Y length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y))
#define OBJECT_SCALE_Z length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))
#define OBJECT_SCALE OBJECT_SCALE_X

#define NOT_REFLECTION_PROBE_RENDER unity_CameraProjection._m11

//#define GET(p) UNITY_ACCESS_INSTANCED_PROP(PROPS, p)
#define GET(p) p

#define TRANSFER_CLIP_POS o.pos = UnityObjectToClipPos(v.vertex);
#define TRANSFER_VIEW_VECTOR(ws) o.V = normalize(UnityWorldSpaceViewDir(ws));
#define TRANSFER_WORLD_NORMAL(n) n = UnityObjectToWorldNormal(v.normal);
#define CALCULATE_WORLD_POSITION(wp) float3 wp = mul(unity_ObjectToWorld, v.vertex).xyz;

inline half3 reflect_NdotV(half3 V, half3 N, half NdotV) {
	return 2 * N * NdotV - V;
}

inline float EaseOutQuad(float x) {
	return x * (2 - x);
}

inline float2 GetWorldSpaceUV(half3 N, float3 ws_pos) {
	return abs(N.x) > .71 ? ws_pos.zy : abs(N.y) > .71 ? ws_pos.xz : ws_pos.xy;
}

inline float3 ApplyWorldSpaceNormalMap(half3 N, half3 map) {
	half snx = sign(N.x);
	half snz = sign(N.z);
	return abs(N.x) > .71 ? half3(map.z * snx, map.y, map.x * snx) : abs(N.y) > .71 ? half3(map.x, map.z * sign(N.y), map.y) : half3(-map.x * snz, map.y, map.z * snz);
}

inline float SmoothStep01(float x) {
	float t = saturate(x);
    return t * t * (3 - t - t);
}

// Optimize
inline float2 ProjectPointToLine(float2 pta, float2 ptb, float2 pt_from) {
	float b1 = pt_from.x * (pta.x - ptb.x) + pt_from.y * (pta.y - ptb.y);
	float b2 = pta.x * ptb.y - pta.y * ptb.x;

	float2 pt_to;
	pt_to.y = (pta.x - ptb.x) * (pta.x - ptb.x) + (pta.y - ptb.y) * (pta.y - ptb.y);
	float det_k = b1 * (pta.x - ptb.x) - b2 * (pta.y - ptb.y);

	pt_to.x = det_k / pt_to.y;
	det_k = (pta.x - ptb.x) * b2 + (pta.y - ptb.y) * b1;
	pt_to.y = det_k / pt_to.y;

	return pt_to;
}

inline float DistSqr(float2 v, float2 w) {
	float2 r = v - w;
	return dot(r, r);
}

inline float DistToSegmentSquared(float2 p, float2 v, float2 w) {
	float l2 = max(DistSqr(v, w), .001);
	float2 w_v = w - v;
	float t = dot(p - v, w_v) / l2;
	t = saturate(t);
	return DistSqr(p, t * w_v + v);
}

inline float DistToSegment(float2 p, float2 v, float2 w) {
	return sqrt(DistToSegmentSquared(p, v, w));
}

inline half2 StadiumNormal(float2 p, float2 v, float2 w) {
	float2 w_v = w - v;
	float2 p_v = p - v;
	float va = dot(w_v, p_v);
	float wa = dot(w_v, w - p);
	float d = va / max(dot(w_v, w_v), .001);
	float2 proj = v + w_v * d;
	float2 c = lerp(proj, v, va < 0);
	c = lerp(c, w, wa < 0);
	return p - c;
}

#define TRANSFER_TANGENT(o)\
half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);\
half tangentSign = v.tangent.w * unity_WorldTransformParams.w;\
half3 wBitangent = cross(normal, wTangent) * tangentSign;\
o.tspace0 = half3(wTangent.x, wBitangent.x, normal.x);\
o.tspace1 = half3(wTangent.y, wBitangent.y, normal.y);\
o.tspace2 = half3(wTangent.z, wBitangent.z, normal.z);

inline half3 ApplyNormalMap(half3 tspace0, half3 tspace1, half3 tspace2, half3 normalmap) {
	half3 N;
	N.x = dot(tspace0, normalmap);
	N.y = dot(tspace1, normalmap);
	N.z = dot(tspace2, normalmap);
	return N;
}

inline half3 HueShift(half3 color, half shift) {
	const float3 k = float3(0.57735, 0.57735, 0.57735);
	half cosAngle = cos(shift);
	return color * cosAngle + cross(k, color) * sin(shift) + k * dot(k, color) * (1.0 - cosAngle);
}

inline half BlinnPhong(half3 L, half3 V, half3 N, half roughness) {
	half3 H = normalize(L + V);
	half specular = dot(N, H);
	//specular = max((specular * .5 - .5 + roughness) * (1 / roughness - 1), 0);
	return specular;
}

half BlinnSpecular(half roughness, half dp)
{
    half m = roughness * roughness;
    half m2 = max(m * m, .0001);
    half n = 2 / m2;
    return n / (2 * PI) * pow(max(dp, .001), n - 2);
}

inline half GeometrySchlickGGX(half NdotV, half k) {
    return NdotV / (NdotV * (1 - k) + k);
}

inline half GeometrySmith(half NdotV, half NdotL, half roughness) {
    half ggx1 = GeometrySchlickGGX(NdotV, roughness);
    half ggx2 = GeometrySchlickGGX(NdotL, roughness);
    return ggx1 * ggx2;
}

inline float3 GetFragmentV(float4 clip_pos) {
	float fov_coef = 2 / unity_CameraProjection._m11;
	float2 screen = clip_pos.xy / _ScreenParams.xy - .5;
	screen.x *= _ScreenParams.x / _ScreenParams.y;
	screen *= fov_coef;
	half3 camera_space_vector = normalize(float3(screen, 1));
	half3 V = mul((float3x3)unity_CameraToWorld, camera_space_vector);
	return -V;
}

inline float3 RestoreWorldPosition(float3 V, float fragDepth) {
	return CAMERA_POS - V * fragDepth;
}

#define OLD_DEVICES_FIX \
int2 pos = i.pos.xy;\
color.rgb *= ((pos.x & pos.y) > 1) * .01 + .99;
