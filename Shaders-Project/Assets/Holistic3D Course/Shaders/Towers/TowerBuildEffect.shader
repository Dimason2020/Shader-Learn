Shader "Custom/TowerBuildEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0)
        _FoamColor ("Foam Color", Color) = (0,0.5,0.5,0)

        _RimPower("Rim Power", Range(1, 10)) = 1
        _BuildSize("Build Size", Range(0, 1)) = 1
        _BuildSizeMultiplier("Build Size Multiplier", Float) = 1
        _FoamWidth("Foam Width", Range(0, 0.2)) = 0.1
    }
    SubShader
    {
        Tags{"Queue" = "Transparent"}

        Pass
        {
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        struct Input
        {
            float3 viewDir;
            float3 worldPos;
        };

        fixed4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim,_RimPower);
            o.Alpha = pow(rim,_RimPower);
        }
        ENDCG

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        fixed4 _RimColor;
        fixed4 _FoamColor;
        float _RimPower;
        float _BuildSize;
        float _BuildSizeMultiplier;
        float _FoamWidth;

        float3 GetFoamEdge(float worldPosY, float3 color)
        {
            return (worldPosY * _BuildSizeMultiplier + _FoamWidth) < _BuildSize ? color : _FoamColor;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = _BuildSize >= 1 ? color : GetFoamEdge(IN.worldPos.y, color);
            o.Alpha = IN.worldPos.y * _BuildSizeMultiplier < _BuildSize ? 1 : 0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
