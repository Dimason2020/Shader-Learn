Shader "Custom/SphereRadius"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _SecondTex("Second Texture", 2D) = "white" {}

        _NoiseTex("Noise Texture", 2D) = "white" {}
        _NScale("Noise Scale", Range(0.1, 2)) = 1
        _NSpeed("Noise Speed", Range(1, 10)) = 1
        _NoiseCutoff("Noise Cutoff", Range(0.01, 0.1)) = 0.01
        _NoiseStrength("Noise Strength", Range(-1, 1)) = 0

        _LineColor("Line Color", Color) = (1,1,1,1)
        _LineWidth("Line Width", Range(0, 0.02)) = 0

        _Color ("Color", Color) = (1,1,1,1)
        _Radius("Radius", Range(0, 10)) = 1

        _Position("Position", Vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SecondTex;
        sampler2D _NoiseTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecondTex;
            float3 worldPos;
            float3 worldNormal;
        };

        fixed4 _Color;
        fixed4 _LineColor;
        float4 _Position;
        float _Radius;
        float _NScale;
        float _NoiseStrength;
        float _LineWidth;
        float _NSpeed;
        float _NoiseCutoff;
        float3 sphereNoise;

        float RadiusNoise(float sphereR, float3 worldNormal, float3 worldPos)
        {
            float3 blendNormal = saturate(pow(worldNormal * 1.4, 4));
            half4 nSide1 = tex2D(_NoiseTex, (worldPos.xy + _Time.x * _NSpeed) * _NScale);
            half4 nSide2 = tex2D(_NoiseTex, (worldPos.xz + _Time.x * _NSpeed) * _NScale);
            half4 nTop = tex2D(_NoiseTex, (worldPos.yz + _Time.x * _NSpeed) * _NScale);

            float3 noiseTexture = nSide1;
            noiseTexture = lerp(noiseTexture, nTop, blendNormal.x);
            noiseTexture = lerp(noiseTexture, nSide2, blendNormal.y);

            sphereNoise = lerp(noiseTexture.r * sphereR, sphereR, _NoiseStrength);
            float radiusCutoff = step(_NoiseCutoff, sphereNoise);
            return radiusCutoff;
        }



        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float dis = distance(IN.worldPos, _Position);
            float sphereR = 1 - saturate(dis / _Radius).r;
            
            float radiusCutoff = RadiusNoise(sphereR, IN.worldNormal, IN.worldPos);
            fixed4 c = float4(radiusCutoff, radiusCutoff,radiusCutoff, 0) * _Color;

            float Line = step(sphereNoise - _LineWidth, _NoiseCutoff) * radiusCutoff;
            float3 coloredLine = Line * _LineColor;

            half4 c1 = tex2D(_MainTex, IN.uv_MainTex);
            half4 c2 = tex2D(_SecondTex, IN.uv_SecondTex);
            half4 combinedTex = lerp(c1, c2, radiusCutoff);

            o.Albedo = combinedTex + coloredLine;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
