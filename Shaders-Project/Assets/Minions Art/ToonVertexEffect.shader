Shader "Toon/VertexEffect" {
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 
		_DisplacementTex ("Displacement Texture", 2D) = "gray" {} 
		_Displacement("Max Displacement", Range(0, 0.2)) = 0.1
		_TimeFactor("Time Factor", Range(0, 1)) = 1
		_ScaleFactor("Scale Factor", Range(0, 10)) = 1
	}
 
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
 
		CGPROGRAM
		#pragma surface surf ToonRamp vertex:vert
		#pragma target 5.0

		sampler2D _Ramp;
 
		// custom lighting function that uses a texture ramp based
		// on angle between light direction and normal
		#pragma lighting ToonRamp exclude_path:prepass
		inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
		{
			#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
			#endif
 
			half d = dot (s.Normal, lightDir)*0.5 + 0.5;
			half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
 
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
			c.a = 0;
			return c;
		}
 
		float4 _Color;
		sampler2D _MainTex, _DisplacementTex;
		float _Displacement;
		float _TimeFactor;
		float _ScaleFactor;

		struct Input {
			float2 uv_MainTex : TEXCOORD0;
			float3 worldPos;
			float4 screenPos;
			float4 dispTex;
		};

		void vert(inout appdata_full v, out Input o)
		{
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; 
			half4 d = tex2Dlod(_DisplacementTex, float4(worldPos.x, (worldPos.y / _ScaleFactor) + (_Time.y * _TimeFactor),0,0));
			UNITY_INITIALIZE_OUTPUT(Input, o);
			v.vertex.xyz += _Displacement * v.normal * d;
			o.dispTex = d;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb + (IN.dispTex * _Color);
			o.Alpha = c.a;
		}
		ENDCG
	} 

	Fallback "Diffuse"
}