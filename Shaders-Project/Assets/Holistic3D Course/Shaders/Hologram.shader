Shader "Custom/Hologram"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0)

        _RimPower("Rim Power", Range(1, 10)) = 1
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

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
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
    }
    FallBack "Diffuse"
}