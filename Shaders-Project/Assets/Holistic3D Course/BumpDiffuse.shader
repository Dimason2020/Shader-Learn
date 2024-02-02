Shader "Custom/BumpDiffuse"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex ("Bump Tex", 2D) = "bump" {}
        _BumpMultiply("Bump Multiply", Range(0,10)) = 1
        _TextureBumpScale("Bump Scale", Range(0.5,5)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpTex;

        float _TextureBumpScale;
        float _BumpMultiply;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex * _TextureBumpScale);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex * _TextureBumpScale));
            o.Normal *= float3(_BumpMultiply, _BumpMultiply, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
