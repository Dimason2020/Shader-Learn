Shader "Toon/Lit" {
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_Color2 ("Color2", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondTex ("Second Tex", 2D) = "white" {}
		_NoiseTex ("Noise", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {} 

		_CutoffSlider("CutOff Slider", Range(0, 0.15)) = 0
	}
 
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
 
		CGPROGRAM
		#pragma surface surf ToonRamp
 
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
 
 
		sampler2D _MainTex;
		sampler2D _SecondTex;
		sampler2D _NoiseTex;
		float4 _Color;
		float4 _Color2;
		float _CutoffSlider;

		struct Input {
			float2 uv_MainTex : TEXCOORD0;
			float3 worldPos;
			float4 screenPos;
		};
 
		float2 GetScreenUV(float4 screenPos) 
		{
			float2 screenUV = screenPos.xy / screenPos.w;
			screenUV *= float2(8,6);	
			return screenUV;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			half4 s = tex2D(_SecondTex, IN.uv_MainTex) * _Color;
			half4 n = tex2D(_NoiseTex, IN.worldPos) * _Color;

			//half4 SP = tex2D(_MainTex, GetScreenUV(IN.screenPos)) * _Color;
			//o.Albedo = SP.rgb;

			//o.Albedo = n.r > _CutoffSlider ? s.rgb : c.rgb;

			o.Albedo = c.rgb * n.rgb;
			o.Emission = n.r > _CutoffSlider ? _Color2 : 0;

			o.Alpha = c.a;
		}
		ENDCG
	} 

	Fallback "Diffuse"
}