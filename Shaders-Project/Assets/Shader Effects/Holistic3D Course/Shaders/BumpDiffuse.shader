Shader "Custom/BumpDiffuse"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex ("Bump Tex", 2D) = "bump" {}
        _BumpMultiply("Bump Multiply", Range(0,10)) = 1
        _TextureBumpScale("Bump Scale", Range(0.5,5)) = 1
        _Brightness("Bump Scale", Range(0,1)) = 1
        _CubeTex("Cube Tex", CUBE) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpTex;
        samplerCUBE _CubeTex;

        float _TextureBumpScale;
        float _BumpMultiply;
        float _Brightness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo =  tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex * _TextureBumpScale)) * _Brightness;
            o.Normal *= float3(_BumpMultiply, _BumpMultiply, 1);

            o.Emission = texCUBE(_CubeTex, WorldReflectionVector(IN, o.Normal)).rgb; 
        }
        ENDCG
    }
    FallBack "Diffuse"
}
